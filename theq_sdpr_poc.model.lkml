
connection: "redshift_pacific_time"
# Set the week start day to Sunday. Default is Monday
week_start_day: sunday
# Set fiscal year to begin April 1st -- https://docs.looker.com/reference/model-params/fiscal_month_offset
fiscal_month_offset: 3

# include all views in this project
include: "/Views/*.view"

# include themes_cache
include: "//cmslite_metadata/Explores/themes_cache.explore.lkml"


datagroup: theq_sdpr_datagroup {
  description: "Datagroup for TheQ SDRP caching"
  max_cache_age: "1 hour"
  sql_trigger: SELECT MAX(latest_time) FROM derived.theq_sdpr_step1 ;;
}

# For now, don't include the dashboard we built. There is an editable version in the Shared -> Service BC Folder
# include: "*.dashboard"

explore: theq_sdpr_poc {
  access_filter: {
    field: office_filter # use the version of office names that have "_" instead of " "
    user_attribute: office_name
  }
  persist_with: theq_sdpr_datagroup
}
explore: theq_sdpr_poc_no_filter {
  from: theq_sdpr_poc
  persist_with: theq_sdpr_datagroup
}

#explore: theq_sdpr_dev {
#  persist_for: "5 minutes"
#}

explore: cats {
  join: cmslite_themes {
    type: left_outer
    sql_on: ${cats.node_id} = ${cmslite_themes.node_id} ;;
    relationship: one_to_one
  }
}

explore: theq_sdpr_all_events {}
