
#!/bin/bash

echo "🛠️ MD 파일 자동 수정 시작합니다."

cd study

# 모든 .md 파일 검색
find . -type f -name "*.md" | while read file; do
  filename=$(basename "$file")
  dirpath=$(dirname "$file")
  filepath="$dirpath/$filename"

  new_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

  # 파일명 변경 필요할 경우
  if [[ "$filename" != "$new_filename" ]]; then
    echo "🔧 파일명 변경: $filename -> $new_filename"
    mv "$filepath" "$dirpath/$new_filename"
    filepath="$dirpath/$new_filename"
  fi

  # layout과 title 추가
  first_line=$(head -n 1 "$filepath")

  if [[ "$first_line" != "---" ]]; then
    # 예쁜 타이틀 만들기 (하이픈->공백, 각 단어 대문자화)
    title=$(basename "$filepath" .md | sed -e 's/-/ /g' -e 's/\b\w/\u&/g')

    # temp 파일에 front matter 추가하고 기존 내용 덮어쓰기
    (echo -e "---\nlayout: default\ntitle: $title\n---\n\n" && cat "$filepath") > temp.md
    mv temp.md "$filepath"
    echo "✅ layout과 title 추가 완료: $filepath"
  fi
done

echo "🎯 모든 수정 작업 완료되었습니다."
