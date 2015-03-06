class CommitPresenter < DigitalOpera::Presenter::Base
  def as_json(include_root=false)
    {
      repo_full_name: self.repo_full_name,
      message: self.message,
      commit: {
        year: self.date.year,
        month: self.date.strftime("%B"),
        day: self.date.day.ordinalize
      },
      additions: self.additions,
      deletions: self.deletions,
      number_of_files: self.number_of_files
    }
  end
end
