ActiveAdmin.register_page "Dashboard" do
  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Servers" do
          table_for Server.order("created_at desc").limit(5) do
            column :title
            column :user
            column :created_at
          end
          strong { link_to "View All Servers", admin_servers_path }
        end
      end
    end
  end
end