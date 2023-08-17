# frozen_string_literal: true

allowed_title_prefixes = %w[
  feat
  fix
  perf
  refactor
  dev
  build
]

appended_allowed_title_prefixes = allowed_title_prefixes.map do |prefix|
  "`#{prefix}`"
end.join(' 、 ')

title_prefix_matched = /^([a-z]+).(\(.+\))?: .*$/.match(github.pr_title)

# rubocop:disable Lint/UnreachableCode
if title_prefix_matched.nil? || title_prefix_matched.length != 3
  fail "PR のタイトルには必ず `feat: 対応内容` のような形式でプレフィックスをつけてください。\n" \
      "許可されているプレフィックスは、 #{appended_allowed_title_prefixes} です。"
  return
end

title_prefix = title_prefix_matched[1]

if !allowed_title_prefixes.include?(title_prefix)
  fail "PR のタイトルに許可されていないプレフィックス `#{title_prefix}` がついています。\n" \
      "#{appended_allowed_title_prefixes} のいずれかをつけてください。"
  return
end
# rubocop:enable Lint/UnreachableCode
