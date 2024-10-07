const RESPONSES = [ "1", "2", "3" ];

fn get_weight(data, difficult) {
    if difficult {
        return 2.0;
    } else if data.next_review <= get_seconds_since_epoch() {
        return 1.0;
    } else {
        return 0.0;
    }
}

fn adjust_card(res, data, difficult) {
    let quality = parse_int(res);
    
    // 新しい範囲（1-3）に合わせて easiness の計算を調整
    data.easiness = max(1.3, data.easiness + 0.1 - (3.0 - quality) * (0.15 + (3.0 - quality) * 0.05));
    
    
    let now = get_seconds_since_epoch();
    let seconds_in_day = 60 * 60 * 24;
    
    if quality == 1 {
        // 難しかった場合は1日後
        data.interval = 2;
        data.next_review = now + seconds_in_day * data.interval;
    } else if quality == 2 {
        // 2回目の正解は1週間後
        data.interval = 7;
        data.next_review = now + seconds_in_day * data.interval;

    } else {
        // 3回目以降の正解は1ヶ月後
        data.interval = 30;
        data.next_review = now + seconds_in_day * data.interval;
    }
    
    data.repetitions = data.repetitions + 1;
    
    return [data, difficult];
}

fn get_default_metadata() {
    return #{
        repetitions: 0,
        easiness: 2.0,
        interval: 1,
        next_review: get_seconds_since_epoch(),
    };
}

fn max(x, y) {
    if x > y { return x; } else { return y; }
}
