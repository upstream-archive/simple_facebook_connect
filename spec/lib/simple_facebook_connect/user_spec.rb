require File.dirname(__FILE__) + '/../../spec_helper'

describe SimpleFacebookConnect::User, 'initialize' do
  before(:each) do
    @session = stub 'session', :post => nil
  end
  
  it "should send a remote call to facebook" do
    @session.should_receive(:post).with('facebook.users.getInfo', :fields => 'uid,hometown_location,first_name,last_name,current_location,pic,locale,email_hashes,about_me,interests', :uids => 8055)
    SimpleFacebookConnect::User.new(8055, @session)
  end
  
  it "should populate the user attributes" do
    @session.stub!(:post).and_yield(user_info_response)
    user = SimpleFacebookConnect::User.new(8055, @session)
    user.email_hashes.should == ["2781152470_9f9c29692798573d8c76eaaf053a1911"]
    user.uid.should == '8055'
    user.hometown_location.should == {"city"=>"York", "state"=>"Pennsylvania", "country"=>"United States"}
    user.first_name.should == 'Dave'
    user.last_name.should == 'Fetterman'
    user.current_location.should == {"city"=>"Palo Alto", "state"=>"California", "country"=>"United States", "zip"=>"94303"}
    user.pic.should == 'http://photos-055.facebook.com/ip007/profile3/1271/65/s8055_39735.jpg'
    user.locale.should == 'en_US'
    user.about_me.should == 'This field perpetuates the glorification of the ego.  Also, it has a character limit.'
    user.interests.should == 'snowboarding, philosophy, soccer, talking to strangers'
  end
  
  it "should expose the session" do
    user = SimpleFacebookConnect::User.new(8055, @session)
    user.session.should == @session
  end
  
  
  def user_info_response
    [{"uid"=>"8055", "about_me"=>"This field perpetuates the glorification of the ego.  Also, it has a character limit.", "activities"=>"Here: facebook, etc. There: Glee Club, a capella, teaching.", "affiliations"=>[{"nid"=>"50453093", "name"=>"Facebook Developers", "type"=>"work", "status"=>"", "year"=>""}], "birthday"=>"November 3", "books"=>"The Brothers K, GEB, Ken Wilber, Zen and the Art, Fitzgerald, The Emporer's New Mind, The Wonderful Story of Henry Sugar", "current_location"=>{"city"=>"Palo Alto", "state"=>"California", "country"=>"United States", "zip"=>"94303"}, "education_history"=>[{"name"=>"Harvard", "year"=>"2003", "concentrations"=>["Applied Mathematics", "Computer Science"]}], "email_hashes"=>["2781152470_9f9c29692798573d8c76eaaf053a1911"], "family"=>[{"family_elt_elt"=>"1394244902"}, {"family_elt_elt"=>"48703107"}, {"family_elt_elt"=>"1078767258"}, {"family_elt_elt"=>""}], "first_name"=>"Dave", "hometown_location"=>{"city"=>"York", "state"=>"Pennsylvania", "country"=>"United States"}, "hs_info"=>{"hs1_name"=>"Central York High School", "hs2_name"=>{}, "grad_year"=>"1999", "hs1_id"=>"21846", "hs2_id"=>"0"}, "is_app_user"=>"1", "has_added_app"=>"1", "interests"=>"snowboarding, philosophy, soccer, talking to strangers", "last_name"=>"Fetterman", "locale"=>"en_US", "meeting_for"=>["Friendship"], "meeting_sex"=>["female"], "movies"=>"Tommy Boy, Billy Madison, Fight Club, Dirty Work, Meet the Parents, My Blue Heaven, Office Space", "music"=>"New Found Glory, Daft Punk, Weezer, The Crystal Method, Rage, the KLF, Green Day, Live, Coldplay, Panic at the Disco, Family Force 5", "name"=>"Dave Fetterman", "notes_count"=>"0", "pic"=>"http://photos-055.facebook.com/ip007/profile3/1271/65/s8055_39735.jpg", "pic_big"=>"http://photos-055.facebook.com/ip007/profile3/1271/65/n8055_39735.jpg", "pic_small"=>"http://photos-055.facebook.com/ip007/profile3/1271/65/t8055_39735.jpg", "pic_square"=>"http://photos-055.facebook.com/ip007/profile3/1271/65/q8055_39735.jpg", "political"=>"Moderate", "profile_update_time"=>"1170414620", "quotes"=>"", "relationship_status"=>"In a Relationship", "religion"=>"", "sex"=>"male", "significant_other_id"=>nil, "status"=>{"message"=>"Fast Company, November issue, page 84", "time"=>"1193075616"}, "timezone"=>"-8", "tv"=>"cf. Bob Trahan", "wall_count"=>"121", "work_history"=>[{"location"=>{"city"=>"Palo Alto", "state"=>"CA", "country"=>"United States"}, "company_name"=>"Facebook", "position"=>"Software Engineer", "description"=>"Tech Lead, Facebook Platform", "start_date"=>"2006-01", "end_date"=>""}]}]
  end
end
