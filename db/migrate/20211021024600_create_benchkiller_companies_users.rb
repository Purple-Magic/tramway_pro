class CreateBenchkillerCompaniesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :benchkiller_companies_users do |t|
      t.integer :company_id
      t.integer :user_id
      t.text :state
      t.integer :project_id

      t.timestamps
    end
  end
end
