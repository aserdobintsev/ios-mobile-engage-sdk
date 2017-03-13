#import "Kiwi.h"
#import "EMSRequestManager.h"
#import "MobileEngage.h"
#import "MobileEngage+Private.h"
#import "MobileEngageStatusDelegate.h"
#import "MEConfigBuilder.h"
#import "MEConfig.h"
#import "EMSRequestModel.h"
#import "EMSRequestModelBuilder.h"
#import "EMSRequestModelMatcher.h"
#import "EMSAuthentication.h"
#import "EMSDeviceInfo.h"
#import "FakeRequestManager.h"
#import "FakeStatusDelegate.h"

static NSString *const kAppId = @"kAppId";

SPEC_BEGIN(PublicInterfaceTest)

    registerMatchers(@"EMS");

    id (^requestManagerMock)() = ^id() {
        NSString *applicationId = kAppId;
        NSString *applicationSecret = @"appSecret";
        NSDictionary *additionalHeaders = @{@"Authorization": [EMSAuthentication createBasicAuthWithUsername:applicationId
                                                                                                    password:applicationSecret]};
        id requestManager = [EMSRequestManager mock];
        [[requestManager should] receive:@selector(setAdditionalHeaders:)
                           withArguments:additionalHeaders];

        MEConfig *config = [MEConfig makeWithBuilder:^(MEConfigBuilder *builder) {
            [builder setCredentialsWithApplicationId:applicationId
                                   applicationSecret:applicationSecret];
        }];

        [MobileEngage setupWithRequestManager:requestManager
                                       config:config
                                launchOptions:nil];
        return requestManager;
    };

    id (^requestModel)(NSString *url, NSDictionary *payload) = ^id(NSString *url, NSDictionary *payload) {
        return [EMSRequestModel makeWithBuilder:^(EMSRequestModelBuilder *builder) {
            [builder setUrl:url];
            [builder setMethod:HTTPMethodPOST];
            [builder setPayload:payload];
        }];
    };

    describe(@"setupWithConfig:launchOptions:", ^{
        it(@"should setup the RequestManager with base64 auth header", ^{
            requestManagerMock();
        });
    });

    describe(@"anonymous appLogin", ^{
        it(@"must not return with nil", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];

            NSString *uuid = [MobileEngage appLogin];
            [[uuid shouldNot] beNil];
        });

        it(@"should return with requestModel's requestId", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            NSString *uuid = [MobileEngage appLogin];
            EMSRequestModel *actualModel = spy.argument;
            [[uuid should] equal:actualModel.requestId];
        });

        it(@"should submit a corresponding RequestModel", ^{
            id requestManager = requestManagerMock();
            EMSRequestModel *model = requestModel(@"https://push.eservice.emarsys.net/api/mobileengage/v2/users/login", @{
                    @"application_id": kAppId,
                    @"platform": @"ios",
                    @"hardware_id": [EMSDeviceInfo hardwareId],
                    @"language": [EMSDeviceInfo languageCode],
                    @"timezone": [EMSDeviceInfo timeZone],
                    @"device_model": [EMSDeviceInfo deviceModel],
                    @"os_version": [EMSDeviceInfo osVersion]
            });

            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            [MobileEngage appLogin];

            EMSRequestModel *actualModel = spy.argument;
            [[model should] beSimilarWithRequest:actualModel];
        });
    });

    describe(@"appLoginWithContactFieldId:contactFieldValue:", ^{
        it(@"must not return with nil", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];

            NSString *uuid = [MobileEngage appLoginWithContactFieldId:@0
                                                    contactFieldValue:@"contactFieldValue"];
            [[uuid shouldNot] beNil];
        });

        it(@"should return with requestModel's requestId", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            NSString *uuid = [MobileEngage appLoginWithContactFieldId:@0
                                                    contactFieldValue:@"contactFieldValue"];
            EMSRequestModel *actualModel = spy.argument;
            [[uuid should] equal:actualModel.requestId];
        });

        it(@"should submit a corresponding RequestModel", ^{
            id requestManager = requestManagerMock();
            EMSRequestModel *model = requestModel(@"https://push.eservice.emarsys.net/api/mobileengage/v2/users/login", @{
                    @"application_id": kAppId,
                    @"platform": @"ios",
                    @"hardware_id": [EMSDeviceInfo hardwareId],
                    @"language": [EMSDeviceInfo languageCode],
                    @"timezone": [EMSDeviceInfo timeZone],
                    @"device_model": [EMSDeviceInfo deviceModel],
                    @"os_version": [EMSDeviceInfo osVersion],
                    @"contact_field_id": @0,
                    @"contact_field_value": @"vadaszRepulogepAnyahajoKabinHajtogatoKeziKeszulek"
            });

            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            [MobileEngage appLoginWithContactFieldId:@0
                                   contactFieldValue:@"vadaszRepulogepAnyahajoKabinHajtogatoKeziKeszulek"];
            EMSRequestModel *actualModel = spy.argument;
            [[model should] beSimilarWithRequest:actualModel];
        });
    });

    describe(@"applogout", ^{
        it(@"must not return with nil", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            NSString *uuid = [MobileEngage appLogout];
            [[uuid shouldNot] beNil];
        });

        it(@"should return with requestModel's requestId", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            NSString *uuid = [MobileEngage appLogout];

            EMSRequestModel *actualModel = spy.argument;
            [[uuid should] equal:actualModel.requestId];
        });

        it(@"should submit a corresponding RequestModel", ^{
            id requestManager = requestManagerMock();
            EMSRequestModel *model = requestModel(@"https://push.eservice.emarsys.net/api/mobileengage/v2/users/logout", @{
                    @"application_id": kAppId,
                    @"hardware_id": [EMSDeviceInfo hardwareId],
            });

            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            [MobileEngage appLogout];

            EMSRequestModel *actualModel = spy.argument;
            [[model should] beSimilarWithRequest:actualModel];
        });
    });

    describe(@"trackMessageOpenWithUserInfo:", ^{
        it(@"must not return with nil", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            NSString *uuid = [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];
            [[uuid shouldNot] beNil];
        });

        it(@"should return with requestModel's requestId", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            NSString *uuid = [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];

            EMSRequestModel *actualModel = spy.argument;
            [[uuid should] equal:actualModel.requestId];
        });

        it(@"should submit a corresponding RequestModel", ^{
            id requestManager = requestManagerMock();

            EMSRequestModel *model = requestModel(@"https://push.eservice.emarsys.net/api/mobileengage/v2/events/message_open", @{
                    @"application_id": kAppId,
                    @"hardware_id": [EMSDeviceInfo hardwareId],
                    @"sid": @"123456789"
            });

            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];

            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];

            EMSRequestModel *actualModel = spy.argument;
            [[model should] beSimilarWithRequest:actualModel];
        });
    });

    describe(@"trackCustomEvent:eventAttributes:", ^{
        it(@"must not return with nil", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            NSString *uuid = [MobileEngage trackCustomEvent:@""
                                            eventAttributes:@{}];
            [[uuid shouldNot] beNil];
        });

        it(@"should return with requestModel's requestId", ^{
            id requestManager = requestManagerMock();
            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];
            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            NSString *uuid = [MobileEngage trackCustomEvent:@""
                                            eventAttributes:@{}];

            EMSRequestModel *actualModel = spy.argument;
            [[uuid should] equal:actualModel.requestId];
        });

        it(@"should throw exception when eventName is nil", ^{
            @try {
                [MobileEngage trackCustomEvent:nil
                               eventAttributes:@{}];
                fail(@"Expected Exception when eventName is nil!");
            } @catch (NSException *exception) {
                [[theValue(exception) shouldNot] beNil];
            }
        });

        it(@"should submit a corresponding RequestModel, when eventAttributes are set", ^{
            id requestManager = requestManagerMock();

            NSString *eventName = @"testEventName";
            NSDictionary *eventAttributes = @{@"someKey": @"someValue"};

            NSDictionary *payload = @{
                    @"application_id": kAppId,
                    @"hardware_id": [EMSDeviceInfo hardwareId],
                    @"attributes": eventAttributes
            };

            EMSRequestModel *model = requestModel([NSString stringWithFormat:@"https://push.eservice.emarsys.net/api/mobileengage/v2/events/%@", eventName], payload);

            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];

            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            [MobileEngage trackCustomEvent:eventName
                           eventAttributes:eventAttributes];
            EMSRequestModel *actualModel = spy.argument;
            [[model should] beSimilarWithRequest:actualModel];
        });


        it(@"should submit a corresponding RequestModel, when eventAttributes are missing", ^{
            id requestManager = requestManagerMock();

            NSString *eventName = @"testEventName";

            NSDictionary *payload = @{
                    @"application_id": kAppId,
                    @"hardware_id": [EMSDeviceInfo hardwareId],
            };

            EMSRequestModel *model = requestModel([NSString stringWithFormat:@"https://push.eservice.emarsys.net/api/mobileengage/v2/events/%@", eventName], payload);

            [[requestManager should] receive:@selector(submit:successBlock:errorBlock:)
                               withArguments:any(), any(), any()];

            KWCaptureSpy *spy = [requestManager captureArgument:@selector(submit:successBlock:errorBlock:)
                                                        atIndex:0];
            [MobileEngage trackCustomEvent:eventName
                           eventAttributes:nil];
            EMSRequestModel *actualModel = spy.argument;
            [[model should] beSimilarWithRequest:actualModel];
        });
    });

    describe(@"statusDelegate", ^{

        id (^statusDelegateMock)(ResponseType responseType) = ^id(ResponseType responseType) {
            FakeRequestManager *requestManager = [FakeRequestManager new];
            [requestManager setResponseType:responseType];

            NSString *applicationId = kAppId;
            NSString *applicationSecret = @"appSecret";
            MEConfig *config = [MEConfig makeWithBuilder:^(MEConfigBuilder *builder) {
                [builder setCredentialsWithApplicationId:applicationId
                                       applicationSecret:applicationSecret];
            }];
            [MobileEngage setupWithRequestManager:requestManager
                                           config:config
                                    launchOptions:nil];
            return [KWMock mockForProtocol:@protocol(MobileEngageStatusDelegate)];
        };

        it(@"should be called with logReceived when anonymusAppLogin is successful", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeSuccess);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage appLogin];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageLogReceivedWithEventId:log:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with errorHappened when anonymusAppLogin is failure", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeFailure);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage appLogin];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageErrorHappenedWithEventId:error:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with logReceived when appLoginWithContact is successful", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeSuccess);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage appLoginWithContactFieldId:@123
                                                       contactFieldValue:@"contactValue"];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageLogReceivedWithEventId:log:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with errorHappened when appLoginWithContact is failure", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeFailure);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage appLoginWithContactFieldId:@123
                                                       contactFieldValue:@"contactValue"];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageErrorHappenedWithEventId:error:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with logReceived when appLogout is successful", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeSuccess);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage appLogout];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageLogReceivedWithEventId:log:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with errorHappened when appLogout is failure", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeFailure);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage appLogout];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageErrorHappenedWithEventId:error:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with logReceived when trackMessageOpenWithUserInfo is successful", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeSuccess);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageLogReceivedWithEventId:log:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with errorHappened when trackMessageOpenWithUserInfo is failure", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeFailure);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageErrorHappenedWithEventId:error:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with errorHappened when trackMessageOpenWithUserInfo is called with missing messageId", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeFailure);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *messageId = [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"no-sid\":\"123456789\"}"}];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageErrorHappenedWithEventId:error:)
                                             withCount:1
                                             arguments:messageId, any()];
        });

        it(@"should be called with logReceived when trackCustomEvent is successful", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeSuccess);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage trackCustomEvent:@"event-name"
                                               eventAttributes:nil];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageLogReceivedWithEventId:log:)
                                             withCount:1
                                             arguments:eventId, any()];
        });

        it(@"should be called with errorHappened when trackCustomEvent is failure", ^{
            id statusDelegate = statusDelegateMock(ResponseTypeFailure);

            [MobileEngage setStatusDelegate:statusDelegate];
            NSString *eventId = [MobileEngage trackCustomEvent:@"event-name"
                                               eventAttributes:nil];

            [[statusDelegate shouldEventually] receive:@selector(mobileEngageErrorHappenedWithEventId:error:)
                                             withCount:1
                                             arguments:eventId, any()];
        });
    });

    describe(@"Main thread", ^{

        void (^setupWithResponseType)(ResponseType responseType) = ^void(ResponseType responseType) {
            FakeRequestManager *requestManager = [FakeRequestManager new];
            [requestManager setResponseType:responseType];

            NSString *applicationId = kAppId;
            NSString *applicationSecret = @"appSecret";
            MEConfig *config = [MEConfig makeWithBuilder:^(MEConfigBuilder *builder) {
                [builder setCredentialsWithApplicationId:applicationId
                                       applicationSecret:applicationSecret];
            }];
            [MobileEngage setupWithRequestManager:requestManager
                                           config:config
                                    launchOptions:nil];
        };

        it(@"should be used for statusDelegate, when anonymous appLogin success happens", ^{
            setupWithResponseType(ResponseTypeSuccess);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage appLogin];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@1];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@0];
        });

        it(@"should be used for statusDelegate, when anonymous appLogin failure happens", ^{
            setupWithResponseType(ResponseTypeFailure);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage appLogin];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@0];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@1];
        });

        it(@"should be used for statusDelegate, when appLogin success happens", ^{
            setupWithResponseType(ResponseTypeSuccess);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage appLoginWithContactFieldId:@0
                                   contactFieldValue:@"contactFieldValue"];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@1];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@0];
        });

        it(@"should be used for statusDelegate, when appLogin failure happens", ^{
            setupWithResponseType(ResponseTypeFailure);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage appLoginWithContactFieldId:@0
                                   contactFieldValue:@"contactFieldValue"];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@0];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@1];
        });

        it(@"should be used for statusDelegate, when appLogout success happens", ^{
            setupWithResponseType(ResponseTypeSuccess);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage appLogout];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@1];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@0];
        });

        it(@"should be used for statusDelegate, when appLogout failure happens", ^{
            setupWithResponseType(ResponseTypeFailure);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage appLogout];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@0];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@1];
        });

        it(@"should be used for statusDelegate, when messageOpen success happens", ^{
            setupWithResponseType(ResponseTypeSuccess);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@1];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@0];
        });

        it(@"should be used for statusDelegate, when messageOpen failure happens", ^{
            setupWithResponseType(ResponseTypeFailure);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage trackMessageOpenWithUserInfo:@{@"u": @"{\"sid\":\"123456789\"}"}];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@0];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@1];
        });

        it(@"should be used for statusDelegate, when messageOpen success happens", ^{
            setupWithResponseType(ResponseTypeSuccess);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage trackCustomEvent:@"eventName"
                           eventAttributes:nil];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@1];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@0];
        });

        it(@"should be used for statusDelegate, when messageOpen failure happens", ^{
            setupWithResponseType(ResponseTypeFailure);
            FakeStatusDelegate *statusDelegate = [FakeStatusDelegate new];

            [MobileEngage setStatusDelegate:statusDelegate];
            [MobileEngage trackCustomEvent:@"eventName"
                           eventAttributes:nil];

            [[expectFutureValue(@(statusDelegate.successCount)) shouldEventually] equal:@0];
            [[expectFutureValue(@(statusDelegate.errorCount)) shouldEventually] equal:@1];
        });

    });

SPEC_END