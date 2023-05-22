#import "MyTrackerSDKPlugin.h"

static NSString *apiChannelName = @"_mytracker_api_channel";

static NSString *initMethod = @"init";
static NSString *trackEventMethod = @"trackEvent";
static NSString *trackLoginEventMethod = @"trackLoginEvent";
static NSString *trackRegistrationEventMethod = @"trackRegistrationEvent";
static NSString *flushMethod = @"flush";
static NSString *isDebugModeMethod = @"isDebugMode";
static NSString *setDebugModeMethod = @"setDebugMode";
static NSString *getIdMethod = @"getId";

static NSString *getBufferingPeriodMethod = @"getBufferingPeriod";
static NSString *getForcingPeriodMethod = @"getForcingPeriod";
static NSString *getLaunchTimeoutMethod = @"getLaunchTimeout";
static NSString *isTrackingEnvironmentEnabledMethod = @"isTrackingEnvironmentEnabled";
static NSString *isTrackingLaunchEnabledMethod = @"isTrackingLaunchEnabled";
static NSString *isTrackingLocationEnabledMethod = @"isTrackingLocationEnabled";
static NSString *setBufferingPeriodMethod = @"setBufferingPeriod";
static NSString *setForcingPeriodMethod = @"setForcingPeriod";
static NSString *setLaunchTimeoutMethod = @"setLaunchTimeout";
static NSString *setProxyHostMethod = @"setProxyHost";
static NSString *setRegionMethod = @"setRegion";
static NSString *setTrackingEnvironmentEnabledMethod = @"setTrackingEnvironmentEnabled";
static NSString *setTrackingLaunchEnabledMethod = @"setTrackingLaunchEnabled";
static NSString *setTrackingLocationEnabledMethod = @"setTrackingLocationEnabled";

static NSString *getAgeMethod = @"getAge";
static NSString *getGenderMethod = @"getGender";
static NSString *getLangMethod = @"getLang";
static NSString *getCustomUserIdMethod = @"getCustomUserIds";
static NSString *getEmailMethod = @"getEmails";
static NSString *getPhoneMethod = @"getPhones";
static NSString *setAgeMethod = @"setAge";
static NSString *setGenderMethod = @"setGender";
static NSString *setLangMethod = @"setLang";
static NSString *setCustomUserIdMethod = @"setCustomUserIds";
static NSString *setEmailMethod = @"setEmails";
static NSString *setPhoneMethod = @"setPhones";

static NSString *idParam = @"id";
static NSString *userIdParam = @"userId";
static NSString *nameParam = @"name";
static NSString *eventParamsParam = @"eventParams";
static NSString *valueParam = @"value";

@implementation MyTrackerSDKPlugin
{
	FlutterMethodChannel *_apiChannel;
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar
{
	MyTrackerSDKPlugin *myTrackerSdkPlugin = [[MyTrackerSDKPlugin alloc] initWithMessenger:[registrar messenger]];

	FlutterMethodChannel *apiChannel = myTrackerSdkPlugin->_apiChannel;
	if (!apiChannel)
	{
		return;
	}

	[registrar addMethodCallDelegate:myTrackerSdkPlugin channel:apiChannel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
	id returnValue = nil;

	NSString *method = [call method];
	id arguments = call.arguments;
	if ([initMethod isEqualToString:method])
	{
		[MRMyTracker setupTracker:arguments[idParam]];
	}
	else if ([flushMethod isEqualToString:method])
	{
		[MRMyTracker flush];
	}
	else if ([trackEventMethod isEqualToString:method])
	{
		[MRMyTracker trackEventWithName:arguments[nameParam] eventParams:[self getEventParams:arguments]];
	}
	else if ([trackLoginEventMethod isEqualToString:method])
	{
		[MRMyTracker trackLoginEvent:arguments[userIdParam] withVkConnectId:nil params:[self getEventParams:arguments]];
	}
	else if ([trackRegistrationEventMethod isEqualToString:method])
	{
		[MRMyTracker trackRegistrationEvent:arguments[userIdParam] withVkConnectId:nil params:[self getEventParams:arguments]];
	}
	else if ([isDebugModeMethod isEqualToString:method])
	{
		returnValue = @(MRMyTracker.isDebugMode);
	}
	else if ([setDebugModeMethod isEqualToString:method])
	{
		[MRMyTracker setDebugMode:((NSNumber *) arguments[valueParam]).boolValue];
	}
	else if ([getIdMethod isEqualToString:method])
	{
		returnValue = MRMyTracker.trackerConfig.trackerId;
	}
	else if ([getBufferingPeriodMethod isEqualToString:method])
	{
		returnValue = @((int) MRMyTracker.trackerConfig.bufferingPeriod);
	}
	else if ([getForcingPeriodMethod isEqualToString:method])
	{
		returnValue = @((int) MRMyTracker.trackerConfig.forcingPeriod);
	}
	else if ([getLaunchTimeoutMethod isEqualToString:method])
	{
		returnValue = @((int) MRMyTracker.trackerConfig.launchTimeout);
	}
	else if ([isTrackingEnvironmentEnabledMethod isEqualToString:method])
	{
		returnValue = @(MRMyTracker.trackerConfig.trackEnvironment);
	}
	else if ([isTrackingLaunchEnabledMethod isEqualToString:method])
	{
		returnValue = @(MRMyTracker.trackerConfig.trackLaunch);
	}
	else if ([isTrackingLocationEnabledMethod isEqualToString:method])
	{
		returnValue = @((BOOL) (MRMyTracker.trackerConfig.locationTrackingMode != MRLocationTrackingModeNone));
	}
	else if ([setBufferingPeriodMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.bufferingPeriod = ((NSNumber *) arguments[valueParam]).doubleValue;
	}
	else if ([setForcingPeriodMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.forcingPeriod = ((NSNumber *) arguments[valueParam]).doubleValue;
	}
	else if ([setLaunchTimeoutMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.launchTimeout = ((NSNumber *) arguments[valueParam]).doubleValue;
	}
	else if ([setProxyHostMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.proxyHost = [self checkedCastWithClass:NSString.class value:arguments[valueParam]];
	}
	else if ([setRegionMethod isEqualToString:method])
	{
		NSInteger value = ((NSNumber *) arguments[valueParam]).integerValue;
		MRRegion region;
		switch (value)
		{
			case 0:
				region = MRRegionRu;
				break;
			case 1:
				region = MRRegionEu;
				break;
			default:
				region = MRRegionNotSet;
				break;
		}

		MRMyTracker.trackerConfig.region = region;
	}
	else if ([setTrackingEnvironmentEnabledMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.trackEnvironment = ((NSNumber *) arguments[valueParam]).boolValue;
	}
	else if ([setTrackingLaunchEnabledMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.trackLaunch = ((NSNumber *) arguments[valueParam]).boolValue;
	}
	else if ([setTrackingLocationEnabledMethod isEqualToString:method])
	{
		MRMyTracker.trackerConfig.locationTrackingMode = ((NSNumber *) arguments[valueParam]).boolValue ? MRLocationTrackingModeCached
		                                                                                                : MRLocationTrackingModeNone;
	}
	else if ([getAgeMethod isEqualToString:method])
	{
		returnValue = MRMyTracker.trackerParams.age;
	}
	else if ([getGenderMethod isEqualToString:method])
	{
		returnValue = @((int) MRMyTracker.trackerParams.gender + 1);
	}
	else if ([getLangMethod isEqualToString:method])
	{
		returnValue = MRMyTracker.trackerParams.language;
	}
	else if ([getCustomUserIdMethod isEqualToString:method])
	{
		returnValue = MRMyTracker.trackerParams.customUserIds.copy;
	}
	else if ([getEmailMethod isEqualToString:method])
	{
		returnValue = MRMyTracker.trackerParams.emails.copy;
	}
	else if ([getPhoneMethod isEqualToString:method])
	{
		returnValue = MRMyTracker.trackerParams.phones.copy;
	}
	else if ([setAgeMethod isEqualToString:method])
	{
		MRMyTracker.trackerParams.age = (NSNumber *) arguments[valueParam];
	}
	else if ([setGenderMethod isEqualToString:method])
	{
		MRMyTracker.trackerParams.gender = (MRGender) ((NSNumber *) arguments[valueParam]).intValue - 1;
	}
	else if ([setLangMethod isEqualToString:method])
	{
		MRMyTracker.trackerParams.language = arguments[valueParam];
	}
	else if ([setCustomUserIdMethod isEqualToString:method])
	{
		MRMyTracker.trackerParams.customUserIds = ((NSArray *) arguments[valueParam]).copy;
	}
	else if ([setEmailMethod isEqualToString:method])
	{
		MRMyTracker.trackerParams.emails = ((NSArray *) arguments[valueParam]).copy;
	}
	else if ([setPhoneMethod isEqualToString:method])
	{
		MRMyTracker.trackerParams.phones = ((NSArray *) arguments[valueParam]).copy;
	}
	else
	{
		returnValue = FlutterMethodNotImplemented;
	}

	result(returnValue);
}

- (instancetype)initWithMessenger:(nonnull NSObject <FlutterBinaryMessenger> *)messenger
{
	self = [super init];
	if (self)
	{
		_apiChannel = [FlutterMethodChannel methodChannelWithName:apiChannelName binaryMessenger:messenger];
	}
	return self;
}

- (id)checkedCastWithClass:(Class)class value:(id)value
{
	if (value && [value isKindOfClass:class])
	{
		return value;
	}

	return nil;
};

- (NSDictionary *)getEventParams:(id)arguments
{
	return [self checkedCastWithClass:NSDictionary.class value:arguments[eventParamsParam]];
}

@end
