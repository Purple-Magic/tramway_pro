#?grequire 'rails_helper'
#?g
#?gdescribe 'Podcast' do
#?g  describe 'Episodes' do
#?g    describe 'Social networks' do
#?g      let!(:project_id) { red_magic_id }
#?g      let!(:podcast) { create :podcast, project_id: project_id }
#?g      let!(:episodes) do
#?g        (1..5).to_a.map do
#?g          create :podcast_episode, podcast: podcast, project_id: project_id
#?g        end
#?g      end
#?g
#?g      before { move_host_to red_magic_host }
#?g
#?g      it 'should return VK post' do
#?g        visit '/admin'
#?g        fill_in 'Email', with: "admin#{project_id}@email.com"
#?g        fill_in 'Пароль', with: '123456'
#?g        click_on 'Войти', class: 'btn-success'
#?g
#?g        click_on 'Подкасты'
#?g        click_on "Выпуск ##{episodes.last.number}"
#?g        
#?g        expect(page).to have_content 'Ведущие'
#?g      end
#?g    end
#?g  end
#?gend
