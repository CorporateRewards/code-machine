class AddMrUserToCodeSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_reference :code_submissions, :mr_user, foreign_key: true
  end
end
