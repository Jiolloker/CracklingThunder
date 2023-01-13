input {
  beats {
    port => 5044
  }
}
filter {
  grok {
    match => { "message" => "(?<event_time>%{MONTHDAY}-%{MONTH}-%{YEAR} %{TIME}) %{WORD:zone}\] PHP %{DATA:level}\:  %{GREEDYDATA:error}"}
      add_tag => "wp_debug"
  }
}


output {
   elasticsearch {
     hosts => ["localhost:9200"]
     index => "wordpress_debug-%{+YYYY.MM.dd}"
   }
}
