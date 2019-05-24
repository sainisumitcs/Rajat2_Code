

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

import com.nuance.tpwrapper.config.TpWrapperProperty;
import com.typesafe.config.Config;
import com.typesafe.config.ConfigFactory;

public final class ConfigurationDetails {


	private static Logger logger = LogManager.getLogger(ConfigurationDetails.class);
	
	Config cfg = null;

	/*Parameter with default values */
	
	private static String loanShortCode;
	private static String loanInterfaces;
	private static String appId;
	private static String selfIP;
	
	
	
	private static String eligibilityCheckInputKeywordList;    /*Keyword input list 
	                                                                 * to initiate new request flow*/ 
	private static String destinationIP;
	private static int udpSocketTimeout;
	private static int receiveBufferSize;
	
	/*Mandatory parameter */
	private static  int destinationPort;
	
	
	
	
	private static int workerThread = 5;

    private static int minThreadToHandleTPAPIReq = 5;
    private static int maxThreadToHandleTPAPIReq = 10;
    private static int idealTimeInSecForExtraThreadToHandleTPAPIReq;

    private static int httpConnPoolSize;
    private static int readTimeoutForTPAPIReqInMilliSec;
    private static int connectionTimeoutForTPAPIReqInMilliSec;

    private static String tpAPIURL;
  
    private static String operator;
    private static int minAonDays;

    private static String uMMIP;
    private static String uMMPort;
    private static String ummAPi;
    private static String displayLoanidVSconfiguredLoanidMapping;
    public static Map<String, String> displayLoanidVSconfiguredLoanidMap = new LinkedHashMap();
    public static Map<String, Integer> evmLoanidVSPriorirtyMap = new HashMap<String, Integer>();
    public static Map<String, String> LoanidVSdisplayLoanidUMMLoanTypeMap = new LinkedHashMap();
    public static Map<String, String> evmLoanidVSLoanShortMsgMap = new HashMap<String, String>();
    public static Map<String, String> evmLoanidVSLoanAckMsgMap = new HashMap<String, String>();
    public static Map<String, String> evmLoanidVSLoansDetailedMessage = new HashMap<String, String>();

    private static Map<String, String> failureErrorCodeStringMapping = new HashMap();
    
    public static int expiryTimeInCacheInSec = 1000;
	
	
	
	
	

	public static String getLoanShortCode() {
		return loanShortCode;
	}

	public static String getLoanInterfaces() {
		return loanInterfaces;
	}

	public static String getAppId() {
		return appId;
	}

	public static String getSelfIP() {
		return selfIP;
	}

	public static String getEligibilityCheckInputKeywordList() {
		return eligibilityCheckInputKeywordList;
	}

	public static String getDestinationIP() {
		return destinationIP;
	}

	public static int getUdpSocketTimeout() {
		return udpSocketTimeout;
	}

	public static int getReceiveBufferSize() {
		return receiveBufferSize;
	}
	

	public static int getDestinationPort() {
		return destinationPort;
	}
	
	

	

	public void populateConfigData(String contextPath) {
	  
	  String configurationFilePath="AirtelThirdPartyAPI";
      //configurationFilePath=DefaultConfigValue.configurationFilePath.replace("<contextpath>",contextPath);
      configurationFilePath="C://Users//rajat.singh//Desktop//NxgEligibilityint//IBMLOAN//config.cfg";
	  
	  Config config = ConfigFactory.parseFile(new File(configurationFilePath));
      cfg = config.getConfig("com.airtelthirdpartyapi");
      
		
		try {
			
			loanShortCode = cfg.getString("airtelthirdpartyapi.loanShortCode").trim();
			loanInterfaces = cfg.getString("airtelthirdpartyapi.loanInterfaces").trim();
			appId = cfg.getString("airtelthirdpartyapi.appId").trim();
			selfIP =cfg.getString("airtelthirdpartyapi.selfIP").trim();
			eligibilityCheckInputKeywordList = cfg.getString("airtelthirdpartyapi.eligibilityCheckInputKeywordList").trim();
			udpSocketTimeout = cfg.getInt("airtelthirdpartyapi.udpSocketTimeout");
			receiveBufferSize =cfg.getInt("airtelthirdpartyapi.receiveBufferSize");
			destinationIP = cfg.getString("airtelthirdpartyapi.destinationIP");
			destinationPort = cfg.getInt("airtelthirdpartyapi.destinationPort");
			
			
			
			 
	            minAonDays = cfg.getInt("airtelthirdpartyapi.aon_days");

	            operator = cfg.getString("airtelthirdpartyapi.operator");
	            
	            displayLoanidVSconfiguredLoanidMapping = cfg
	                    .getString("airtelthirdpartyapi.DisplayLoanidVSconfiguredLoanidMapping");

	            uMMIP = cfg.getString("tpwrapper.ummIp");
	            uMMPort = cfg.getString("tpwrapper.ummPort");
	            ummAPi = cfg.getString("tpwrapper.ummAPi");

	            expiryTimeInCacheInSec = cfg.hasPath("airtelthirdpartyapi.expiryTimeInCacheInSec") 
	                ? cfg.getInt("airtelthirdpartyapi.expiryTimeInCacheInSec") : expiryTimeInCacheInSec ;
	            
	            minThreadToHandleTPAPIReq = cfg.hasPath("tpwrapper.minThreadToHandleTPAPIReq")
	                    ? cfg.getInt("tpwrapper.minThreadToHandleTPAPIReq") : minThreadToHandleTPAPIReq;

	            maxThreadToHandleTPAPIReq = cfg.hasPath("tpwrapper.maxThreadToHandleTPAPIReq")
	                    ? cfg.getInt("tpwrapper.maxThreadToHandleTPAPIReq") : maxThreadToHandleTPAPIReq;

	            idealTimeInSecForExtraThreadToHandleTPAPIReq = cfg
	                    .hasPath("tpwrapper.idealTimeInSecForExtraThreadToHandleTPAPIReq")
	                            ? cfg.getInt("tpwrapper.idealTimeInSecForExtraThreadToHandleTPAPIReq")
	                            : idealTimeInSecForExtraThreadToHandleTPAPIReq;

	            tpAPIURL = cfg.getString("tpwrapper.tpAPIURL");

	            httpConnPoolSize = cfg.hasPath("tpwrapper.httpConnPoolSize") ? cfg.getInt("tpwrapper.httpConnPoolSize")
	                    : httpConnPoolSize;
	            readTimeoutForTPAPIReqInMilliSec = cfg.hasPath("tpwrapper.readTimeoutForTPAPIReqInMilliSec")
	                    ? cfg.getInt("tpwrapper.readTimeoutForTPAPIReqInMilliSec") : readTimeoutForTPAPIReqInMilliSec;

	            connectionTimeoutForTPAPIReqInMilliSec = cfg.hasPath("tpwrapper.connectionTimeoutForTPAPIReqInMilliSec")
	                    ? cfg.getInt("tpwrapper.connectionTimeoutForTPAPIReqInMilliSec")
	                    : connectionTimeoutForTPAPIReqInMilliSec;

	            int count = 1;
	            String failureRuleArray[] = null;
	            
	            while (true) {
	                /*
	                 * if (cfg.getString("failure_rule_mapping_" + count) != null &&
	                 * cfg.getString("failure_rule_mapping_" +
	                 * count).trim().length() > 0) {
	                 */

	                if (cfg.hasPath("failure_rule_mapping_" + count + "")) {

	                    failureRuleArray = cfg.getString("failure_rule_mapping_" + count).split("=");

	                    if (failureRuleArray != null && failureRuleArray.length > 0) {
	                        failureErrorCodeStringMapping.put(failureRuleArray[0].toUpperCase(), failureRuleArray[1]);

	                    }
	                }
	                if (failureRuleArray == null) {
	                    break;
	                }
	                failureRuleArray = null;
	                count++;
	            }
	            
	            populatEvmLoanidVSLoanShortMsgMap(cfg);
	            populatEvmLoanidVSLoanAckMsgMap(cfg);
	            populatEvmLoanidVSLoanDetailedMessage(cfg);
	            populateTPWrapperConfig();
	            fillLoanCofiguration(displayLoanidVSconfiguredLoanidMapping);
			

		} catch (Exception e) {
			logger.error("Some Error occure while reading config file");
			logger.error("Exception", e);

		}

	}

	



  public static int getWorkerThread() {
    return workerThread;
  }

  public static void setWorkerThread(int workerThread) {
    ConfigurationDetails.workerThread = workerThread;
  }

  public static int getMinThreadToHandleTPAPIReq() {
    return minThreadToHandleTPAPIReq;
  }

  public static void setMinThreadToHandleTPAPIReq(int minThreadToHandleTPAPIReq) {
    ConfigurationDetails.minThreadToHandleTPAPIReq = minThreadToHandleTPAPIReq;
  }

  public static int getMaxThreadToHandleTPAPIReq() {
    return maxThreadToHandleTPAPIReq;
  }

  public static void setMaxThreadToHandleTPAPIReq(int maxThreadToHandleTPAPIReq) {
    ConfigurationDetails.maxThreadToHandleTPAPIReq = maxThreadToHandleTPAPIReq;
  }

  public static int getIdealTimeInSecForExtraThreadToHandleTPAPIReq() {
    return idealTimeInSecForExtraThreadToHandleTPAPIReq;
  }

  public static void setIdealTimeInSecForExtraThreadToHandleTPAPIReq(int idealTimeInSecForExtraThreadToHandleTPAPIReq) {
    ConfigurationDetails.idealTimeInSecForExtraThreadToHandleTPAPIReq = idealTimeInSecForExtraThreadToHandleTPAPIReq;
  }

  public static int getHttpConnPoolSize() {
    return httpConnPoolSize;
  }

  public static void setHttpConnPoolSize(int httpConnPoolSize) {
    ConfigurationDetails.httpConnPoolSize = httpConnPoolSize;
  }

  public static int getReadTimeoutForTPAPIReqInMilliSec() {
    return readTimeoutForTPAPIReqInMilliSec;
  }

  public static void setReadTimeoutForTPAPIReqInMilliSec(int readTimeoutForTPAPIReqInMilliSec) {
    ConfigurationDetails.readTimeoutForTPAPIReqInMilliSec = readTimeoutForTPAPIReqInMilliSec;
  }

  public static int getConnectionTimeoutForTPAPIReqInMilliSec() {
    return connectionTimeoutForTPAPIReqInMilliSec;
  }

  public static void setConnectionTimeoutForTPAPIReqInMilliSec(int connectionTimeoutForTPAPIReqInMilliSec) {
    ConfigurationDetails.connectionTimeoutForTPAPIReqInMilliSec = connectionTimeoutForTPAPIReqInMilliSec;
  }

  public static String getTpAPIURL() {
    return tpAPIURL;
  }

  public static void setTpAPIURL(String tpAPIURL) {
    ConfigurationDetails.tpAPIURL = tpAPIURL;
  }


  public static String getOperator() {
    return operator;
  }

  public static void setOperator(String operator) {
    ConfigurationDetails.operator = operator;
  }

  public static int getMinAonDays() {
    return minAonDays;
  }

  public static void setMinAonDays(int minAonDays) {
    ConfigurationDetails.minAonDays = minAonDays;
  }

  public static String getuMMIP() {
    return uMMIP;
  }

  public static void setuMMIP(String uMMIP) {
    ConfigurationDetails.uMMIP = uMMIP;
  }

  public static String getuMMPort() {
    return uMMPort;
  }

  public static void setuMMPort(String uMMPort) {
    ConfigurationDetails.uMMPort = uMMPort;
  }

  public static String getUmmAPi() {
    return ummAPi;
  }

  public static void setUmmAPi(String ummAPi) {
    ConfigurationDetails.ummAPi = ummAPi;
  }

  public static String getDisplayLoanidVSconfiguredLoanidMapping() {
    return displayLoanidVSconfiguredLoanidMapping;
  }

  public static void setDisplayLoanidVSconfiguredLoanidMapping(String displayLoanidVSconfiguredLoanidMapping) {
    ConfigurationDetails.displayLoanidVSconfiguredLoanidMapping = displayLoanidVSconfiguredLoanidMapping;
  }

  public static Map<String, String> getDisplayLoanidVSconfiguredLoanidMap() {
    return displayLoanidVSconfiguredLoanidMap;
  }

  public static void setDisplayLoanidVSconfiguredLoanidMap(Map<String, String> displayLoanidVSconfiguredLoanidMap) {
    ConfigurationDetails.displayLoanidVSconfiguredLoanidMap = displayLoanidVSconfiguredLoanidMap;
  }

  public static Map<String, Integer> getEvmLoanidVSPriorirtyMap() {
    return evmLoanidVSPriorirtyMap;
  }

  public static void setEvmLoanidVSPriorirtyMap(Map<String, Integer> evmLoanidVSPriorirtyMap) {
    ConfigurationDetails.evmLoanidVSPriorirtyMap = evmLoanidVSPriorirtyMap;
  }

  public static Map<String, String> getLoanidVSdisplayLoanidUMMLoanTypeMap() {
    return LoanidVSdisplayLoanidUMMLoanTypeMap;
  }

  public static void setLoanidVSdisplayLoanidUMMLoanTypeMap(Map<String, String> loanidVSdisplayLoanidUMMLoanTypeMap) {
    LoanidVSdisplayLoanidUMMLoanTypeMap = loanidVSdisplayLoanidUMMLoanTypeMap;
  }

  public static Map<String, String> getEvmLoanidVSLoanShortMsgMap() {
    return evmLoanidVSLoanShortMsgMap;
  }

  public static void setEvmLoanidVSLoanShortMsgMap(Map<String, String> evmLoanidVSLoanShortMsgMap) {
    ConfigurationDetails.evmLoanidVSLoanShortMsgMap = evmLoanidVSLoanShortMsgMap;
  }

  public static Map<String, String> getEvmLoanidVSLoanAckMsgMap() {
    return evmLoanidVSLoanAckMsgMap;
  }

  public static void setEvmLoanidVSLoanAckMsgMap(Map<String, String> evmLoanidVSLoanAckMsgMap) {
    ConfigurationDetails.evmLoanidVSLoanAckMsgMap = evmLoanidVSLoanAckMsgMap;
  }

  public static Map<String, String> getEvmLoanidVSLoansDetailedMessage() {
    return evmLoanidVSLoansDetailedMessage;
  }

  public static void setEvmLoanidVSLoansDetailedMessage(Map<String, String> evmLoanidVSLoansDetailedMessage) {
    ConfigurationDetails.evmLoanidVSLoansDetailedMessage = evmLoanidVSLoansDetailedMessage;
  }

  public static Map<String, String> getFailureErrorCodeStringMapping() {
    return failureErrorCodeStringMapping;
  }

  public static void setFailureErrorCodeStringMapping(Map<String, String> failureErrorCodeStringMapping) {
    ConfigurationDetails.failureErrorCodeStringMapping = failureErrorCodeStringMapping;
  }

  public static int getExpiryTimeInCacheInSec() {
    return expiryTimeInCacheInSec;
  }

  public static void setExpiryTimeInCacheInSec(int expiryTimeInCacheInSec) {
    ConfigurationDetails.expiryTimeInCacheInSec = expiryTimeInCacheInSec;
  }

  public static void setLoanShortCode(String loanShortCode) {
    ConfigurationDetails.loanShortCode = loanShortCode;
  }

  public static void setLoanInterfaces(String loanInterfaces) {
    ConfigurationDetails.loanInterfaces = loanInterfaces;
  }

  public static void setAppId(String appId) {
    ConfigurationDetails.appId = appId;
  }

  public static void setSelfIP(String selfIP) {
    ConfigurationDetails.selfIP = selfIP;
  }

  public static void setEligibilityCheckInputKeywordList(String eligibilityCheckInputKeywordList) {
    ConfigurationDetails.eligibilityCheckInputKeywordList = eligibilityCheckInputKeywordList;
  }

  public static void setDestinationIP(String destinationIP) {
    ConfigurationDetails.destinationIP = destinationIP;
  }

  public static void setUdpSocketTimeout(int udpSocketTimeout) {
    ConfigurationDetails.udpSocketTimeout = udpSocketTimeout;
  }

  public static void setReceiveBufferSize(int receiveBufferSize) {
    ConfigurationDetails.receiveBufferSize = receiveBufferSize;
  }

  public static void setDestinationPort(int destinationPort) {
    ConfigurationDetails.destinationPort = destinationPort;
  }


  public void populateTPWrapperConfig()  {

    TpWrapperProperty.getInstance().minThreadToHandleTPAPIReq = minThreadToHandleTPAPIReq;
    TpWrapperProperty.getInstance().maxThreadToHandleTPAPIReq = maxThreadToHandleTPAPIReq;
    TpWrapperProperty.getInstance().idealTimeInSecForExtraThreadToHandleTPAPIReq = idealTimeInSecForExtraThreadToHandleTPAPIReq;

    TpWrapperProperty.getInstance().tpAPIURL = tpAPIURL;
    TpWrapperProperty.getInstance().httpConnPoolSize = httpConnPoolSize;
    TpWrapperProperty.getInstance().readTimeoutForTPAPIReqInMilliSec = readTimeoutForTPAPIReqInMilliSec;
    TpWrapperProperty.getInstance().connectionTimeoutForTPAPIReqInMilliSec = connectionTimeoutForTPAPIReqInMilliSec;

}

private static void populatEvmLoanidVSLoanShortMsgMap(com.typesafe.config.Config cfg){
  int count = 1;
  String tempArr[] = null;
  while (true) {
      if (cfg.hasPath("evmLoanId_loanShortMessage_" + count + "")) {
          tempArr = cfg.getString("evmLoanId_loanShortMessage_" + count).trim().split("=");
          if (tempArr != null && tempArr.length > 0) {
              evmLoanidVSLoanShortMsgMap.put(tempArr[0], tempArr[1]);
          }
      } else{
          break;
      }
      tempArr = null;
      count++;
  }
}

private static void populatEvmLoanidVSLoanAckMsgMap(com.typesafe.config.Config cfg) {
  int count = 1;
  String tempArr[] = null;
  while (true) {
    if (cfg.hasPath("evmLoanId_loanAcknowledgmentMessage_" + count + "")) {
      tempArr = cfg.getString("evmLoanId_loanAcknowledgmentMessage_" + count).trim().split("=");
      if (tempArr != null && tempArr.length > 0) {
        evmLoanidVSLoanAckMsgMap.put(tempArr[0], tempArr[1]);
      }
    } else {
      break;
    }
    tempArr = null;
    count++;
  }
}

private static void fillLoanCofiguration(String displayLoanidVSconfiguredLoanidMapping) {

    String displayLoanidVSconfiguredLoanidMappingArray[] = displayLoanidVSconfiguredLoanidMapping.split("#");

    int priority = 1;
    for (String loanMap : displayLoanidVSconfiguredLoanidMappingArray) {

        String map[] = loanMap.split("\\:");
        displayLoanidVSconfiguredLoanidMap.put(map[0], map[1]);
        LoanidVSdisplayLoanidUMMLoanTypeMap.put(map[1], map[0]);
        

        evmLoanidVSPriorirtyMap.put(map[0], priority);
        priority++;
    }
}

   private static void populatEvmLoanidVSLoanDetailedMessage(com.typesafe.config.Config cfg) {
          int count = 1;
          String tempArr[] = null;
          while (true) {
            if (cfg.hasPath("evmLoanId_vs_LoanDetailedMessage_" + count + "")) {
              tempArr = cfg.getString("evmLoanId_vs_LoanDetailedMessage_" + count).trim().split("=");
              if (tempArr != null && tempArr.length > 0) {
                evmLoanidVSLoansDetailedMessage.put(tempArr[0], tempArr[1]);
              }
            } else {
              break;
            }
            tempArr = null;
            count++;
          }
        }



}
