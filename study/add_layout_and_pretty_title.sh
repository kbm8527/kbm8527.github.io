
#!/bin/bash

# study 폴더로 이동
cd study

# 모든 .md 파일 찾기
find . -type f -name "*.md" | while read file; do
  # 파일의 첫 줄 읽기
  first_line=$(head -n 1 "$file")
  
  # 파일명 추출
  filename=$(basename "$file" .md)
  
  # 파일명이 하이픈으로 되어 있을 때 이쁘게 변환: 하이픈을 띄어쓰기로, 각 단어 첫 글자 대문자
  title=$(echo "$filename" | sed -e 's/-/ /g' -e "s/\b\w/\u&/g")
  
  # 만약 첫 줄이 "---"로 시작하지 않으면
  if [[ "$first_line" != "---" ]]; then
    echo "🔧 Adding layout and formatted title to: $file"
    # 임시 파일 생성 후 layout과 예쁜 title 추가하고 기존 내용 붙이기
    (echo -e "---\nlayout: default\ntitle: $title\n---\n\n" && cat "$file") > temp.md
    mv temp.md "$file"
  fi
done

echo "✅ 모든 md 파일에 layout: default + 이쁜 title 추가 완료"
