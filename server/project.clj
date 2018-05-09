(defproject allo-workday "0.1.0-SNAPSHOT"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [compojure "1.5.1"]
                 [ring/ring-defaults "0.2.1"]
                 [org.clojure/java.jdbc "0.7.5"]
                 [org.xerial/sqlite-jdbc "3.7.2"]
                 [org.clojure/data.json "0.2.6" ]]
  :plugins [[lein-ring "0.9.7"]
            [lein-cljfmt "0.5.7"]]
  :ring {:handler allo-workday.handler/app}
  :profiles
  {:dev {:dependencies [[javax.servlet/servlet-api "2.5"]
                        [ring/ring-mock "0.3.0"]]}})
