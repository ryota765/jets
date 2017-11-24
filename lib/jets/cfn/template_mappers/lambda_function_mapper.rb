class Jets::Cfn::TemplateMappers
  class LambdaFunctionMapper
    def initialize(task)
      @task = task
      @app_class = task.class_name.to_s
      # @app_class examples: PostsController, HardJob, Hello, HelloFunction
    end

    # Example: SleepJobPerformLambdaFunction
    def logical_id
      "#{class_action}LambdaFunction".gsub('::','')
    end

    def environment
      env = Jets.config.environment ? Jets.config.environment.to_h : {}
      env.deep_merge(JETS_ENV: Jets.env.to_s)
    end

    # Example: PostsControllerIndex or SleepJobPerform
    def class_action
      "#{@app_class}_#{@task.meth}".camelize
    end

    # Examples:
    #   "#{Jets.config.project_namespace}-sleep_job-perform"
    #   "demo-dev-sleep_job-perform"
    def function_name
      # Example values:
      #   @app_class: admin/pages_controller
      #   @task.meth: index
      method = @app_class.underscore
      # method: admin/pages_controller
      method = method.sub('/','-') + "-#{@task.meth}"
      # method: admin-pages_controller-index
      "#{Jets.config.project_namespace}-#{method}"
    end

    def handler
      underscored = @app_class.underscore
      "handlers/#{@task.type.pluralize}/#{underscored}.#{@task.meth}"
    end

    def code_s3_key
      Jets::Naming.code_s3_key
    end
  end
end
