require_relative '../../../../lib/imports/constants_and_requires'

module Template

  class Templates

    def issue_template(issue, error, steps, query, vnum=VERSION, agent='N/A', ruby_version=RUBY_VERSION)
      template = <<~_TEMPLATE_
Before you create an issue please make sure that there are no issues that relate to your issue. if there is an issue that relates to one, please add a comment to that issue and describe your specific problem. If your issue has to do with any sort of installation or syntax errors, please read the self_help under the docs directory. If none of those answer your question, make an issue
--

## Issue/Enhancement/Question (be specific)
#{issue}

## Exact error message/Enhancment information
#{error}

## Steps to reproduce if applicable or steps on what should be done
#{steps}

## Search query if applicable (please use exact search query)
#{query}

## User agent (if applicable)
#{agent}

## Whitewidow version number (must have the actual version run `ruby whitewidow.rb --version`)
#{vnum}

## Ruby version number (run ruby --version)
#{ruby_version}
      _TEMPLATE_
      File.open("#{ISSUE_TEMPLATE_PATH}/#{SETTINGS.random_issue_name}.txt", 'a+') { |issues| issues.puts(template) }
    end

  end

end