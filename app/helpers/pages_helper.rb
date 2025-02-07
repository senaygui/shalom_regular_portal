module PagesHelper
  def sub_total(fee, number)
    fee / number
  end

  def total(fee, number, registration_fee)
    sub_total(fee, number) + registration_fee 
  end

  #def leadtotal(fee, registration_fee, number)

   # (fee + registration_fee) / 4
     
  #end
end
