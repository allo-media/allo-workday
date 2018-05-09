(ns allo-workday.handler
  (:require [compojure.core :refer :all]
            [compojure.handler :as handler]
            [compojure.route :as route]
            [ring.middleware.json :as middleware]
            [clojure.java.jdbc :as jdbc]))

(def db
  {:classname   "org.sqlite.JDBC"
   :subprotocol "sqlite"
   :subname     "db/database.db"})

(defn get_projects
  []
  (let [results (jdbc/query db ["SELECT * FROM Projects"])]
    (cond (empty? results)
          ("Empty Db")
          :else
          (lazy-seq results))))

(defn post_days
  [req]

  (let [date (or (get-in req [:params :date])
                 (get-in req [:body :date])
                 "DATE_failed")
        morning (or (get-in req [:params :morning])
                    (get-in req [:body :morning])
                    "MORNING_failed")
        afternoon (or (get-in req [:params :afternoon])
                      (get-in req [:body :afternoon])
                      "AFTERNOON_failed")
        comments (or (get-in req [:params :comment])
                     (get-in req [:body :comment])
                     "COMMENTS_failed")]

    (jdbc/insert! db :Days
                  {:Date date :Morning morning :Afternoon afternoon :Comments comments})))

(defroutes app-routes
  (GET "/" [] "Hello World")

  (GET "/projects" []
    {:status 200
     :headers {"Content-Type" "application/json; charset=utf-8"}
     :body (get_projects)})

  (POST "/personal/days" response (post_days response))

  (route/not-found "Not Found"))

(def app
  (-> (handler/site app-routes)
      (middleware/wrap-json-body {:keywords? true})
      middleware/wrap-json-response))
