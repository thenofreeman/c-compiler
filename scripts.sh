runit() {
  local filename=$1

  gcc
    -S # Emit assembly instead of binary (don't run assembler/linker)
    -O # Optimize code
    -fno-asynchronous-unwind-tables # No Unwind table (it is used for debugging)
    -fcf-protection=none # Disable control-flow protection (it is a security feature)
    $filename
}
