(ns hello-world.handler
  (:require [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [clojure.java.jdbc :as jdbc]
            [clojure.data.json :as json]))

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

(defroutes app-routes
           (GET "/" [] "Hello World")

           (GET "/projects" []
                {:status 200
                 :headers {"Content-Type" "application/json; charset=utf-8"}
                 :body (json/write-str (get_projects))})

           (route/not-found "Not Found"))

(def app
  (wrap-defaults app-routes site-defaults))
