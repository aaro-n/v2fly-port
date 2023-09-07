#!/bin/bash
# 读取config文件
config_file="config"
protocol=""
link=""
port=""

while IFS=':' read -r key value; do
  key=$(echo "$key" | tr -d '[:space:]')
  value=$(echo "$value" | tr -d '[:space:]')

  if [[ $key == "trojan_protocol" ]]; then
    protocol="$value"
  elif [[ $key == "trojan_link" ]]; then
    link="$value"
  elif [[ $key == "trojan_port" ]]; then
    port="$value"
  fi
done < "$config_file"

# 检查protocol是否为trojan
if [[ $protocol != "trojan" ]]; then
  echo "protocol不是trojan"
  exit 1
fi

# 解析port范围
start_port=$(echo "$port" | cut -d'-' -f1)
end_port=$(echo "$port" | cut -d'-' -f2)

# 清空trojan文件
> "trojan.txt"

# 替换link中的端口号并输出到trojan文件
for ((p = start_port; p <= end_port; p++)); do
  replaced_link=$(echo "$link" | sed "s/\(:.*:\).*\(\?.*\)/\1$p\2/; s/#\(.*\)$/#\1-$p/")
  echo "$replaced_link" >> "trojan.txt"
done

echo "操作完成"

