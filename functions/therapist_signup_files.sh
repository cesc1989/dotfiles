## Explore Therapist Signup Bucket in Alpha
#
# Use:
#
#     alpha_signup_files [UUID]
#
# Example:
#
#    alpha_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb
#
#    alpha_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb/attestation
#
function alpha_signup_files() {
  setaws alpha

  s3ls "luna-alpha-workloads-therapist-signup/$1/"
}

## Explore Therapist Signup Bucket in Omega
#
# Use:
#
#     omega_signup_files [UUID]
function omega_signup_files() {
  setaws omega

  s3ls "luna-omega-workloads-therapist-credentialing/$1/"
}

## Copy Omega Therapist Signup files to local folder
#
# Use:
#
#     omega_copy_signup_files [UUID] [FILE_NAME]
function omega_copy_signup_files() {
  setaws omega

  s3cp "s3://luna-omega-workloads-therapist-credentialing/$1/$2" "$HOME/Downloads/$1/"
}

## Copy Alpha Therapist Signup files to local folder
#
# Use:
#
#     alpha_copy_signup_files [UUID] [FILE_NAME]
#
# Example:
#
#    alpha_copy_signup_files fc5eb1bb-89ba-45d5-abe5-3f444ca1eebb attestation/friendly_packet_2025-05-12.pdf
#
function alpha_copy_signup_files() {
  setaws alpha

  s3cp "s3://luna-alpha-workloads-therapist-signup/$1/$2" "$HOME/Downloads/$1/"
}
