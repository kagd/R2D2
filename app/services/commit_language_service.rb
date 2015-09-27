class CommitLanguageService
  class << self
    MAPPING = {
      css: %w(scss less css),
      html: %w(jade html),
      javascript: %w(npmignore jshintrc js handlebars hbs walrus wal dust json bson bowerrc Jakefile coffee js Cakefile cson),
      ruby: %w(Procfile ru Gemfile rails erb rb jpbuilder jbuilder slim Rakefile guard haml rspec gemspec rdoc),
      php: %w(php),
      python: %w(py),
      shell: %w(buildignore extra sh functions Makefile bash_profile htaccess)
    }

    # Get the percentages for each language
    def percentages
      languages = []
      total_files = 0

      MAPPING.each do |language, array|
        language_file_count =  CommitLanguage.where(extention: array).size
        total_files = total_files + language_file_count

        languages << {
          language: language,
          number_of_files: language_file_count
        }
      end

      languages.each do |language|
        # add .to_f otherwise it does stupid int division
        percentage = ((language[:number_of_files].to_f / total_files.to_f) * 100).round(2)
        language[:percentage] = percentage
      end

      languages.sort_by!{|language| language[:percentage] }.reverse
    end
  end
end
