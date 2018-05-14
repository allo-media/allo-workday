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

(defn insert_projects
  [list_to_insert id_date]
  (cond (empty? list_to_insert)
        (println "End of Recursion")
        :else
        (let [id_projects (or (get (first list_to_insert) :id)
                              "ID_failed")
              hours (or (get (first list_to_insert) :hours)
                        "HOURS_failed")]
          ;(println id_projects " " hours)
          (jdbc/insert! db :Projects_On_Days
                        {:Heures hours :ID_Users 1 :ID_Date id_date :Id_Projects id_projects})
          (insert_projects (rest list_to_insert) id_date))))
;)


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
                     "COMMENTS_failed")
        list_projects (or (get-in req [:params :projects])
                          (get-in req [:body :projects])
                          "PROJECTS_failed")]

    (let [key_date (first (vals (first (jdbc/insert! db :Days
                                                     {:ID_Users 1 :Date date :Morning morning :Afternoon afternoon :Comments comments}))))]
      (insert_projects list_projects key_date))))

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
