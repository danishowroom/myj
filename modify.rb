#!/usr/bin/ruby
# coding: utf-8
require "~/qiniu_sdk.rb"


ARGF.inplace_mode = ""


file_name =  "./_org/" + File.basename(ARGF.path,".*") + ".org"
f = File.new( file_name )

ARGF.rewind

f.each_line do |line|
 
  title = line[/^\#\+title:(.*)/,1]
  tags = line[/^\#\+tags:(.*)/,1]

  if title
    $title = title
  end
  if tags
    $tags = tags
    break
  end

end

# Write into the post's meta:
# ---
# title: 
# tags: [  ]
# ---

ARGF.puts("---", "title: #{$title}","tags: [ #{$tags} ]" ,"---","")

# Replace images address

images = [];

ARGF.each_line do |line|
  if /(images\/.+?jpg)/ =~ line
    images << $1
  end
  
  print line.sub("../images", "{{site.img_host}}/images")
end


$stdout = STDOUT

puts $title
# Upload images
buc = 'danishowroom'

images.each do |filePath|

  key = 'myj/images/' + File.basename( filePath )

  put_policy = Qiniu::Auth::PutPolicy.new(
    buc, # 存储空间
    key,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
    3600    # token 过期时间，默认为 3600 秒，即 1 小时
  )

  uptoken = Qiniu::Auth.generate_uptoken(put_policy)

  code, result, response_headers = Qiniu::Storage.upload_with_token_2(
                  uptoken,
                  filePath,
                  key,
                  nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
                  bucket: buc
                )
  #打印上传返回的信息
  puts result,"Upload seccess" if code == 200

end
  

