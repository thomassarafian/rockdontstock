class Guide < ApplicationRecord
  before_create :set_default_image
  after_create :create_sendinblue_list

  attribute :newsletter, :boolean
  
  def fetch_sendinblue
    sib = SibApiV3Sdk::ContactsApi.new
    lists = sib.get_folder_lists(14).as_json["lists"]
    lists.find {|list| list["id"] == self.sendinblue_list_id}
  end

  private

  def set_default_image
    self.img_url = "/assets/oeil-rds.png"
  end
  
  # folder 14 contains legit check lists
  def create_sendinblue_list
    sib = SibApiV3Sdk::ContactsApi.new
    new_list = SibApiV3Sdk::CreateList.new({name: self.name, folderId: 14}.as_json)
    response = sib.create_list(new_list)

    # store sendinblue_id for easy access
    self.update(sendinblue_list_id: response.as_json["id"])
  end

  # not automatically deleted for now
  # def delete_sendinblue_list
  #   SIB = SibApiV3Sdk::ContactsApi.new
  #   lists = SIB.get_folder_lists(14).as_json["lists"]
  #   match = lists.find {|list| list["name"] === self.name}
  #   SIB.delete_list(match["id"]) if match
  # end
  
end
