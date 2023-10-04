module ApplicationHelper
    def custom_date_format(date)
        current_time = Time.now
        if date > current_time - 24.hours
            # 投稿が24時間以内の場合、時間のみを表示
            date.strftime("%k時%M分")
        elsif date > current_time - 1.year
            # 投稿が1年以内の場合、日付を表示
            date.strftime("%m月%d日")
        else
            # 1年以上経過した場合、年月日を表示
            date.strftime("%Y年%m月%d日")
        end
    end
end
