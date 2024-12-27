for path in public/d/*.html; do
  sed -i '' 's^http://wholesomecoolness.thisistheremix.dev^/^g' "${path}"
done
