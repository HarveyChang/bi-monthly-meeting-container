#!/bin/bash

# 獲取 Minikube 的 IP 地址
minikube_ip=$(minikube ip)

# 初始化一個空的陣列來存儲結果
results=()

# 執行 20 次 curl 指令並擷取第三行
for i in {1..50}; do
  third_line=$(curl -s http://$minikube_ip | sed -n '3p')
  results+=("$third_line")
done

# 去除重複的結果並列出
unique_results=$(printf "%s\n" "${results[@]}" | sort -u)

echo "$unique_results"
echo "------------------------------------------"