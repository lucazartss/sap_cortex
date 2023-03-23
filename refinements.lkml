include: "/views/**/*.view.lkml"
# include: "//cortex-sap-operational/**/*.explore.lkml"

# #
# Use LookML refinements to refine views and explores defined in the remote project.
# Learn more at: https://docs.looker.com/data-modeling/learning-lookml/refinements
#
#
# For example we could add a new dimension to a view:
#     view: +flights {
#       dimension: air_carrier {
#         type: string
#         sql: ${TABLE}.air_carrier ;;
#       }
#     }
#
# Or apply a label to an explore:
#     explore: +aircraft {
#       label: "Aircraft Simplified"
#     }
#

view: +data_intelligence_otc {

  parameter: Currency_Required{
    type: string
    allowed_value: {
      label: "USD"
      value: "USD"
    }
    allowed_value: {
      label: "EUR"
      value: "EUR"
    }
    allowed_value: {
      label: "CAD"
      value: "CAD"
    }
    allowed_value: {
      label: "JPY"
      value: "JPY"
    }
    allowed_value: {
      label: "BRL"
      value: "BRL"
    }
  }

  dimension: Exchange_Rate_of_blocked_order_Value{
    value_format: "0.00"
    type: number
    sql: ${blocked_order_value_Local_Currency}/NULLIF(${blocked_order_value_Global_Currency},0);;
  }

  dimension: Exchange_Rate_of_Delivered_Value{
    value_format: "0.00"
    type: number
    sql: ${delivered_value_Local_Currency}/NULLIF(${delivered_value_Global_Currency},0);;
  }

  dimension: Exchange_Rate_Billing_net_value{
    value_format: "0.00"
    type: number
    sql: ${billing_Net_Value_Local_Currecy}/NULLIF(${billing_Net_Value_Local_Currecy},0);;
  }

  dimension: Exchange_Rate_intercompany_price{
    value_format: "0.00"
    type: number
    sql: ${intercompany_price_Local_currency}/NULLIF(${list_price_Global_currency},0);;
  }

  measure: OnTimePercentage {
    type: number
    value_format: "0%"
    sql: if(${count_of_deliveries}=0,0,round(${count_on_time_delivery}/NULLIF(${count_of_deliveries},0),2))  ;;
  }

  measure: InFullPercentage {
    type: number
    value_format: "0%"
    sql: if(${count_of_deliveries}=0,0,round(${count_in_full_delivery}/NULLIF(${count_of_deliveries},0),2))  ;;
  }

  measure: OTIFPercentage {
    type: number
    value_format: "0%"
    sql: if(${count_of_deliveries}=0,0,round(${count_otif}/NULLIF(${count_of_deliveries},0),2))  ;;
  }

  measure: LateDeliveryPercentage {
    type: number
    value_format: "0%"
    sql: if(${count_of_deliveries}=0,0,round(${count_latedeliveries}/NULLIF(${count_of_deliveries},0),2))  ;;
  }

  measure: avg_order_line_items {
    type: number
    sql: round(${count_sales_orders_line_item}/NULLIF(${Total_Sales_Orders_AVG},0),2) ;;
  }

  measure: average_deliveries_sales_orders {
    type: number
    sql: round(${count_deliveries_sales_orders}/NULLIF(${Total_Delevery_Order_AVG},0),2) ;;
  }

  measure: Return_Order_Percentage {
    type: number
    sql: ${count_return_order}/NULLIF(${count_of_delivery},0) ;;
    link: {
      label: "Returned Orders"
      url: "/dashboards/cortex_sap_operational::returned_orders?"
    }
    #drill_fields: [sales_order,sales_order_line_item,product, Sold_To_Party, Ship_To_Party, Bill_To_Party,order_status,sales_order_qty,Base_UoM,Exchange_Rate_Sales_Value,Sales_Order_Value_Global_Currency,Global_Currency,sales_order_value_Local_Currecny,Local_Currency_Key]
  }

  measure: Cancelled_Order_Percentage {
    type: number
    sql: ${count_canceled_order}/NULLIF(${data_intelligence_otc.count},0) ;;
    link: {
      label: "Canceled Orders"
      url: "/dashboards/cortex_sap_operational::canceled_orders?"
    }

  }

  dimension: Exchange_Rate_Tax_Amount{
    value_format: "0.00"
    type: number
    sql: ${Tax_Amount_Local_Currency}/NULLIF(${list_price_Global_currency},0);;
  }

  dimension: Exchange_Rate_Sales_Net_Value{
    value_format: "0.00"
    type: number
    sql: ${sales_order_net_value_Local_Currency}/NULLIF(${sales_order_net_value_Global_Currency},0);;
  }

  dimension: Exchange_Rate_Sales_Value{
    value_format: "0.00"
    type: number
    sql: ${sales_order_value_Local_Currecny}/NULLIF(${Sales_Order_Value_Global_Currency},0);;
  }

  dimension: Exchange_Rate_Billing{
    value_format: "0.00"
    type: number
    sql: if(${list_price_Global_currency}=0,0,${list_price_Local_Currency}/NULLIF(${list_price_Global_currency},0));;
  }

  measure: percentage_one_touch_order {
    type: number
    sql: ${count_one_touch_order}/NULLIF(${count_incoming_order},0)*100 ;;
    link: {
      label: "One Touch Order"
      url: "/dashboards/cortex_sap_operational::one_touch_order?"
    }
  }







  ############################################################################################################################






}


view: +data_intelligence_ar {
  measure: Total_DSO {
    type: number
    sql: floor(if(${Sales_Total_DSO}=0,0,(${AccountsRecievables_Total_DSO}/NULLIF(${Sales_Total_DSO},0))*{% parameter Day_Sales_Outstanding %}*30)) ;;
    #sql: floor(if(${Sales_Total_DSO}=0,0,(${AccountsRecievables_Total_DSO}/${Sales_Total_DSO})*date_diff(DATE_SUB(${Current_Fiscal_Date_date},INTERVAL {% parameter Day_Sales_Outstanding %} MONTH ),${Current},days))) ;;

    link: {
      label: "Day Sales Outstanding"
      url: "/dashboards/cortex_sap_operational::day_sales_outstanding?"
    }
  }

  measure: DSO{
    type: number
    sql: floor(if(${Sales_Total_DSO}=0,0,(${AccountsRecievables_Total_DSO}/NULLIF(${Sales_Total_DSO},0))*{% parameter Day_Sales_Outstanding %}*30)) ;;
  }

}
