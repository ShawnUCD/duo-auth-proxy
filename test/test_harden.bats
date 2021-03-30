@test "There are no suid files" {
  suid_count=$(docker run --rm --entrypoint find duoauthproxy -type f -a -perm +4000 | wc -l)
  [[ ${suid_count} -eq 0 ]]
}

@test "duo user exists" {
  run docker run --rm --entrypoint getent duoauthproxy passwd
  [[ ${lines[0]} =~ ^duo ]]
}

@test "duo user is denied interactive login" {
  run docker run --rm --entrypoint getent duoauthproxy passwd
  [[ ${lines[0]} =~ :/sbin/nologin$ ]]
}

@test "duo is the only user account" {
  if [[ -n ${CIRCLECI} ]]; then
    skip "This should work on circle but does not"
  fi
  run docker run --rm --entrypoint getent duoauthproxy passwd
  [[ ${#lines[@]} -eq 1 ]]
}

@test "duo is the only user account" {
  users=$(docker run --rm --entrypoint getent duoauthproxy passwd | wc -l)
  [[ ${users} -eq 1 ]]
}

@test "duo group exists" {
  run docker run --rm --entrypoint getent duoauthproxy group
  [[ ${lines[0]} =~ ^duo ]]
}

@test "duo is the only group account" {
  if [[ -n ${CIRCLECI} ]]; then
    skip "This should work on circle but does not"
  fi
  run docker run --rm --entrypoint getent duoauthproxy group
  [[ ${#lines[@]} -eq 1 ]]
}

@test "duo is the only group account" {
  groups=$(docker run --rm --entrypoint getent duoauthproxy group | wc -l)
  [[ ${groups} -eq 1 ]]
}

@test "bash is available" {
  run docker run --rm --entrypoint sh duoauthproxy -c "command -v bash"
  [[ ${status} -eq 0 ]]
}

@test "chown is available" {
  run docker run --rm --entrypoint chown duoauthproxy --help
  [[ ${output} =~ "Usage: chown" ]]
}

@test "chgrp is available" {
  run docker run --rm --entrypoint chgrp duoauthproxy --help
  [[ ${output} =~ "Usage: chgrp" ]]
}

@test "ln is available" {
  run docker run --rm --entrypoint sh duoauthproxy -c "command -v ln"
  [[ ${status} -eq 0 ]]
}

@test "chmod is available" {
  run docker run --rm --entrypoint sh duoauthproxy -c "command -v chmod"
  [[ ${status} -eq 0 ]]
}
