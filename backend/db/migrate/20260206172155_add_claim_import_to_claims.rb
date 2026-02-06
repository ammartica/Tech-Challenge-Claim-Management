class AddClaimImportToClaims < ActiveRecord::Migration[7.1]
  def change
    add_reference :claims, :claim_import, type: :uuid, foreign_key: true
  end
end
