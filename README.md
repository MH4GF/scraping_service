# Scraping Service

特定のWebページをスクレイピングし、結果をSlackへ送信する。
現状はマネーフォワードMEに対応している。

![diagram](./diagram.png)

## Getting Started

1. bundle install
```
cd src
bundle install --deployment
```

2. ソースコードのzip化、アップロード(s3バケットは事前に作っておく)
```
cd ..
sam package \
  --template-file template.yml \
  --output-template-file packaged-template.yml \
  --s3-bucket ort-scraping-service \ # fix to your bucket name
  --profile ort # fix to your profile
```

3. デプロイ
```
sam deploy \
  --template-file packaged-template.yml \
  --stack-name ort-scraping-service \
  --capabilities CAPABILITY_IAM \
  --profile ort
```

## ローカルでのデバッグ
sam localでローカルでの実行が可能。
```
$ sam local invoke ScrapingService --no-event
```
