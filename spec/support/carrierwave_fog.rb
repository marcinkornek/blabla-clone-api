# frozen_string_literal: true

Fog.mock!
connection = Fog::Storage.new(
  provider: "AWS",
  aws_access_key_id: ENV["S3_ACCESS_KEY_ID"],
  aws_secret_access_key: ENV["S3_SECRET_ACCESS_KEY"],
  region: ENV["S3_REGION"],
)
connection.directories.create(key: ENV["S3_BUCKET"])
