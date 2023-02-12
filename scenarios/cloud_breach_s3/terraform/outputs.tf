
#Required: Always output the AWS Account ID
output "cloudgoat_output_aws_account_id" {
  value = "${data.aws_caller_identity.aws-account-id.account_id}"
}
output "cloudgoat_output_target_ec2_server_ip" {
  value = "${aws_instance.ec2-vulnerable-proxy-server.public_ip}"
}
output "cloudgoat_output_s3_bucket" {
  value = "${aws_s3_bucket.cg-cardholder-data-bucket.id}"
}