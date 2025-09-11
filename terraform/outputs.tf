output "cd_user_access_key_id" {
  description = "AWS key ID for CD user"
  value       = simple-web-app-usr.cd
  sensitive   = true
}

output "cd_user_access_key_secret" {
  description = "Access Key secret for CD user"
  value       = simple-web-app-usr.cd.secret
  sensitive   = true

}
