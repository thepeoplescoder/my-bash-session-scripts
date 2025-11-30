# Initialization script — must be sourced first by .bashrc,
# .bash_profile, or any shell entrypoint.
#
# Functions and definitions here are intended for use during startup,
# not for persistence in the interactive shell. Treat this as a transient
# setup layer: once initialization completes, its contents should not
# remain in scope.
#
# If sourced from an executable script, variables and functions
# behave normally, persisting the same way as they would in any
# other subshell.
#
# Source only as many times as required — no more.
# For example, .bash_profile may source .bashrc,
# but .bashrc does not source .bash_profile.
#
# Each entrypoint should source this file independently if it requires the initial environment.
#
# All included files implement silent include guards.
# This allows redundant sourcing without side effects,
# but inclusion should still be minimal and intentional.
#
# It should go without saying that individual files in this directory should
# not be sourced directly by outsiders, they should all be sourced indirectly
# at once via this file.
#
# Any files in this directory that source any of its siblings do so for
# declarative/documentation purposes.
#

#################################################################
# Bootstrap functions that are assumed to exist everywhere else #
#################################################################

# This file uses a function that's defined in a future file.
# It's fine because the function isn't called until it's defined.
# It also defines unset_on_exit, which is used heavily.
source "$(dirname "${BASH_SOURCE[0]}")/on_exit.sh"
source "$(dirname "${BASH_SOURCE[0]}")/init_phase_two.sh"

source "$(dirname "${BASH_SOURCE[0]}")/initial_utility_functions_for_paths.sh"
source "$(dirname "${BASH_SOURCE[0]}")/set___MY_INCLUDE_DIR__.sh"
source "$(dirname "${BASH_SOURCE[0]}")/initial_utility_functions.sh"