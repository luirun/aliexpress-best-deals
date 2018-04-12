require 'rails_helper'

describe ProductLike do
  describe '.create_like' do
    context 'recives not unqiue product and user Id' do
      it 'warn administrator that unwanted action was allowed by UI' do
        
      end
    end

    context 'recives unique product and user ID' do
      it 'saves product like to database' do

      end
    end
  end

  describe '.destroy_like' do

  end
end