# 投稿タイプを作成
PostType.seed(:name) do |s|
  s.name = 'article'
  s.name_j = '記事'
end

PostType.seed(:name) do |s|
  s.name = 'question'
  s.name_j = '質問'
end
