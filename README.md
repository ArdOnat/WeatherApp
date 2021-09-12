# WeatherApp

An iOS application that allows users to view weather status at desirable locations.

In WeatherApp, I focused on Uncle Bob's Clean Architecture principles. (https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

![Screen Shot 2021-08-03 at 11 28 16](https://user-images.githubusercontent.com/37045606/132954720-84db1607-72e0-4210-a94a-16627498fa8b.png)

I designed 4 different modules for having clean, scalable, testable modules that do not have unnecessary dependencies to other modules or third party libraries..

<img width="1243" alt="Screen Shot 2021-09-09 at 13 13 26" src="https://user-images.githubusercontent.com/37045606/132987445-b8fd6c56-bd47-45e1-beb8-c2506ef009cc.png">


1 - [Core Module](https://github.com/ArdOnat/CoreModule) - (Yellow Layer in Uncle Bob's Architecture)
Module that keeps entities that will be used by multiple modules. In Clean Architecture principle, it is very important that these entities do not depend on any other module.


2 - [ApiClient Module](https://github.com/ArdOnat/ApiClient) - (Green Layer in Uncle Bob's Architecture)
Module that is responsible for making network requests. It uses models and protocols that are defined in CoreModule. Also uses Alamofire library as helper. As Alamofire is only used as a helper and implementation of this module can be easily changed to other solutions like URLSession, without effecting other modules, dependency to Alamofire does not break the Clean Architecture rules. (Alamofire is the Blue Layer in Uncle Bob's Architecture.)

ApiClient uses Singleton as design pattern so it can not be manually initialized.

![Screen Shot 2021-09-12 at 14 58 43](https://user-images.githubusercontent.com/37045606/132986686-cd659216-8616-4d69-9cfb-3f05595be3b8.png)

Before using ApiClient.shared, ApiCient has to be set up with default url and body parameters at AppDelegate didFinishLaunching. If needed, these parameters can be used to set up default parameters to be sent at each network request.

![Screen Shot 2021-09-12 at 15 06 33](https://user-images.githubusercontent.com/37045606/132986919-293cbdd8-e0d5-4c39-8e87-e9b6a5efffad.png)

In application's main module, enums that conform to the NetworkEnvironment protocol have to be created for each API environment that the application will interact with.(For WeatherApp only WeeatherForecastEnvironment is needed.)

<img width="535" alt="WeatherForecastEnvironment swift" src="https://user-images.githubusercontent.com/37045606/132987624-8bee6d39-1c0a-439e-a81a-17ce4901c77f.png">

ApiClient has to be extended in main application, to fulfill each UI Module's ApiClient needs. These extensions has to initialize requests that UI Module needs using the ApiEnvironment that is initialized with NetworkEnvironment. With this operation, ApiClient is going to have the knowledge of which request will be sent to which NetworkEnvironment. After request initialization is completed, this request value has to be passed to ApiClient's generic request function.

![Screen Shot 2021-09-12 at 15 10 56](https://user-images.githubusercontent.com/37045606/132987038-92f0936c-cfe3-431d-83a2-34d7ab645b1f.png)

After the extension is implemented, ApiClient.shared can be used as a parameter to generate UI Module.

<img width="667" alt="Screen Shot 2021-09-09 at 21 05 59" src="https://user-images.githubusercontent.com/37045606/132986962-3c5baa38-c324-4641-9664-20d361177031.png">


3 - [Home Module](https://github.com/ArdOnat/HomeModule) - (Green Layer in Uncle Bob's Architecture)
Home Module is an UI Module that is designed with VIPER UI Design Pattern.

![Screen Shot 2021-09-12 at 15 45 05](https://user-images.githubusercontent.com/37045606/132988060-600a2cdc-e7dd-490f-afaf-b8351c54d125.png)

Each UI Module has an request struct (In HomeModule -> HomePageRequest) that conforms to the Request protocol in CoreModule.

![Screen Shot 2021-09-12 at 15 47 53](https://user-images.githubusercontent.com/37045606/132988152-c9565cfa-cdea-4ed2-8893-d4f6f45bd258.png)

Each UI Module has an service class (In HomeModule -> HomeService) that defines a public API protocol (In HomeModule -> HomeApi) so ApiClient or some other network module can conform to it. 

![Screen Shot 2021-09-12 at 15 50 30](https://user-images.githubusercontent.com/37045606/132988218-c047c388-d0bb-4b36-9028-6efaf238f6b9.png)

Service module does not hold any references to any third party library, ApiClient, or any concrete type. So if needed or desired, ApiClient can be changed with any other network module that conforms to the HomeApi protocol which opens up a lot of opportunities.
