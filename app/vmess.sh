#!/bin/bash

# 读取config文件
config_file="config"
protocol=""
link=""
port=""

while IFS=':' read -r key value; do
  key=$(echo "$key" | tr -d '[:space:]')
  value=$(echo "$value" | tr -d '[:space:]')

  if [[ $key == "vmess_protocol" ]]; then
    protocol="$value"
  elif [[ $key == "vmess_link" ]]; then
    link="$value"
  elif [[ $key == "vmess_port" ]]; then
    port="$value"
  fi
done < "$config_file"

# 检查protocol是否为vmess
if [[ $protocol != "vmess" ]]; then
  echo "protocol不是vmess"
  exit 1
fi

# 解析port范围
start_port=$(echo "$port" | cut -d'-' -f1)
end_port=$(echo "$port" | cut -d'-' -f2)

# 清空vmess.txt文件
> "vmess.txt"

# 解码link并替换端口号和ps后重新编码
decoded_link=$(echo "$link" | sed 's/^vmess:\/\///' | base64 -d)
ps_value=$(echo "$decoded_link" | jq -r '.ps')
for ((p = start_port; p <= end_port; p++)); do
  replaced_link=$(echo "$decoded_link" | sed "s/\"port\":.*,/\"port\": \"$p\",/" | sed "s/\"ps\": \"$ps_value\",/\"ps\": \"$ps_value-$p\",/")
  encoded_link=$(echo "$replaced_link" | base64)
  echo "vmess://$encoded_link" >> "vmess.txt"
done

echo "操作完成"

# 整理vmess.txt文件
output_file="vmess_clean.txt"
input_file="vmess.txt"

# 清空输出文件
> "$output_file"

# 读取输入文件
while IFS= read -r line; do
  if [[ $line == "vmess://"* ]]; then
    # 遇到新的 vmess:// 开头的行，将之前的内容整理后写入输出文件
    if [[ -n $vmess_line ]]; then
      echo -n "$vmess_line" >> "$output_file"
      echo >> "$output_file"
    fi
    vmess_line="$line"
  else
    # 将当前行追加到 vmess_line 变量中
    vmess_line+=" $line"
  fi
done < "$input_file"

# 处理最后一个 vmess:// 开头的行
if [[ -n $vmess_line ]]; then
  echo -n "$vmess_line" >> "$output_file"
  echo >> "$output_file"
fi

# 删除原来的vmess.txt文件
rm "$input_file"

# 重命名vmess_clean.txt为vmess.txt
mv "$output_file" "$input_file"

echo "整理完成，结果保存在 $input_file"
