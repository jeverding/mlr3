#' @title TaskGenerator Class
#'
#' @include mlr_reflections.R
#'
#' @description
#' Creates a [Task] of arbitrary size.
#' Predefined task generators are stored in the [dictionary][mlr3misc::Dictionary] [mlr_task_generators],
#' e.g. [`xor`][mlr_task_generators_xor].
#'
#' @template param_id
#' @template param_param_set
#' @template param_task_type
#' @template param_packages
#' @template param_man
#'
#' @family TaskGenerator
#' @export
TaskGenerator = R6Class("TaskGenerator",
  public = list(
    #' @template field_id
    id = NULL,

    #' @template field_task_type
    task_type = NULL,

    #' @template field_param_set
    param_set = NULL,

    #' @template field_packages
    packages = NULL,

    #' @template field_man
    man = NULL,

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    initialize = function(id, task_type, packages = character(), param_set = ParamSet$new(), man = NA_character_) {
      self$id = assert_string(id, min.chars = 1L)
      self$param_set = assert_param_set(param_set)
      self$packages = assert_set(packages)
      self$task_type = assert_choice(task_type, mlr_reflections$task_types$type)
      self$man = assert_string(man, na.ok = TRUE)

      check_packages_installed(packages, msg = sprintf("Package '%%s' required but not installed for TaskGenerator '%s'", id))
    },

    #' @description
    #' Creates a task of type `task_type` with `n` observations, possibly using additional settings stored in `param_set`.
    #'
    #' @param n (`integer(1)`)\cr
    #'   Number of rows to generate.
    #' @return [Task].
    generate = function(n) {
      n = assert_count(n, coerce = TRUE)
      require_namespaces(self$packages)
      private$.generate(n)
    }
  )
)
