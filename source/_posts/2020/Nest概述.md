---
title: Nest概述
tags:
  - typescript
copyright: true
comments: true
date: 2020-11-30 09:25:42
categories: JS
photos:
---

## 先决条件

一分钟安装`nodejs`，版本(**>=10.13.0**)

## 创建项目

```bash
npm i -g @nestjs/cli

nest new project

# 或者 git 安装
git clone https://github.com/nestjs/typescript-starter.git nest-crud-demo

# 操作数据库
npm install mongoose @nestjs/mongoose --save
```

### 启动服务

```bash
cd nest-crud-demo
npm run start:dev 或者 yarn run start:dev
# dev 模式启动，这样 Nest 会自动检测文件变化，然后自动重启服务。
```

### 初始项目结构

```bash
# 将创建 project 目录， 安装node模块和一些其他样板文件，并将创建一个 src 目录，目录中包含几个核心文件。
src
├── app.controller.ts # 带有单个路由的基本控制器示例。
├── app.module.ts # 应用程序的根模块
└── main.ts # 应用程序入口文件。它使用 NestFactory 用来创建 Nest 应用实例。
```

```ts
// main.ts
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
```

### 平台

Nest 旨在成为一个与平台无关的框架。 通过平台，可以创建可重用的逻辑部件，开发人员可以利用这些部件来跨越多种不同类型的应用程序。 从技术
上讲，Nest 可以在创建适配器后使用任何 Node HTTP 框架。 有两个支持开箱即用的 HTTP 平台：express 和 fastify。 您可以选择最适合您
需求的产品。

| 平台                                                                                             | 描述                                                                                                                   |
| :----------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------- |
| express                                                                                          | Express 是一个众所周知的 node.js 简约 Web 框架。 这是一个经过实战考验，适用于生产的库，拥有大量社区资源。 默认情况下使 |
| 用 `@nestjs/platform-express` 包。 许多用户都可以使用 Express ，并且无需采取任何操作即可启用它。 |
| fastify                                                                                          | Fastify 是一个高性能，低开销的框架，专注于提供最高的效率和速度。 在[这里](https://docs.nestjs.cn/7/techniques?         |
| id=%e6%80%a7%e8%83%bd%ef%bc%88fastify%ef%bc%89)阅读如何使用它。                                  |

无论使用哪种平台，它都会暴露自己的 API。 它们分别是 NestExpressApplication 和 NestFastifyApplication。

将类型传递给 NestFactory.create() 函数时，如下例所示，app 对象将具有专用于该特定平台的函数。 但是，请注意，除非您确实要访问底层平
台 API，否则无需指定类型。

```js
const app = (await NestFactory.create) < NestExpressApplication > AppModule;
```

### 运行应用程序

```js
npm run start

// http://localhost:3000 Hello World
```

---

<!--more-->

## 控制器

> 控制器负责处理传入的 请求 和向客户端返回 响应 。

![控制器](http://cdn.mydearest.cn/blog/images/nest-controller.png)

控制器的目的是接收应用的特定请求。路由机制控制哪个控制器接收哪些请求。通常，每个控制器有多个路由，不同的路由可以执行不同的操作。

为了创建一个基本的控制器，我们使用类和装饰器。装饰器将类与所需的元数据相关联，并使 Nest 能够创建路由映射（将请求绑定到相应的控制器）
。

```ts
// cats.controller.ts
import { Controller, Get } from "@nestjs/common";
import { Request } from "express";

@Controller("cats")
export class CatsController {
  @Get()
  findAll(@Req() request: Request): string {
    return "This action returns all cats";
  }
}
```

> 要使用 CLI 创建控制器，只需执行 `nest g controller cats` 命令。
> 为了在 express 中使用 Typescript （如 request: Request 上面的参数示例所示），请安装 @types/express 。

- 装饰器和普通表达对象的比较
  |装饰器|普通表达对象|
  |:---|:---|
  |@Request()|req|
  |@Response() @Res()\*|res|
  |@Next()|next|
  |@Session()|req.session|
  |@Param(key?: string)|req.params / req.params[key]|
  |@Body(key?: string)|req.body / req.body[key]|
  |@Query(key?: string)|req.query / req.query[key]|
  |@Headers(name?: string)|req.headers / req.headers[name]|
  |@Ip()|req.ip|

### Http 请求方法

- @Get()
- @Post()
- @Put()
- @Options()
- @Patch()
- @Delete()
- @Head()
- @All()

### 通配符

```ts
@Get('ab*cd')
findAll() {
  return 'This route uses a wildcard';
}
```

### 状态码/响应头

```ts
import { HttpCode, Header } from '@nestjs/common';
@Post()
@HttpCode(204)
@Header('Cache-Control', 'none')
create() {
  return 'This action adds a new cat';
}
```

### 重定向

```ts
@Get()
@Redirect('https://nestjs.com', 301)

// 动态重定向
@Get('docs')
@Redirect('https://docs.nestjs.com', 302)
getDocs(@Query('version') version) {
  if (version && version === '5') {
    return { url: 'https://docs.nestjs.com/v5/' };
  }
}
```

### 路由参数

```ts
@Get(':id')
findOne(@Param() params): string {
  console.log(params.id);
  return `This action returns a #${params.id} cat`;
}
```

### 子域路由

```ts
@Controller({ host: "admin.example.com" })
export class AdminController {
  @Get()
  index(): string {
    return "Admin page";
  }
}
```

> 因为 Fastify 缺乏对嵌套路由器的支持，当使用子域路由时，应该使用(默认) Express 适配器。

```ts
@Controller({ host: ':account.example.com' })
export class AccountController {
@Get()
getInfo(@HostParam('account') account: string) {
  return account;
}
```

### Async/await

```ts
@Get()
async findAll(): Promise<any[]> {
  return [];
}

// RxJS observable 流
@Get()
findAll(): Observable<any[]> {
  return of([]);
}
```

### 请求负载

- DTO(数据传输对象)模式

```ts
// create-cat.dto.ts
export class CreateCatDto {
  readonly name: string;
  readonly age: number;
  readonly breed: string;
}

@Post()
async create(@Body() createCatDto: CreateCatDto) {
  return 'This action adds a new cat';
}
```

### 注册 controller

控制器已经准备就绪，可以使用，但是 Nest 不知道 CatsController 是否存在，所以它不会创建这个类的一个实例。

控制器总是属于模块，这就是为什么我们将 controllers 数组保存在 @module() 装饰器中。

```ts
// app.module.ts
import { Module } from "@nestjs/common";
import { CatsController } from "./cats/cats.controller";

@Module({
  controllers: [CatsController],
})
export class AppModule {}
```

## 提供者

> Providers 是 Nest 的一个基本概念。许多基本的 Nest 类可能被视为 provider - service, repository, factory, helper 等
> 等。 他们都可以通过 constructor 注入依赖关系。 这意味着对象可以彼此创建各种关系，并且“连接”对象实例的功能在很大程度上可以委托给
> Nest 运行时系统。 Provider 只是一个用 @Injectable() 装饰器注释的类。

![](http://cdn.mydearest.cn/blog/images/nest-provider.png)

### 服务

```ts
// interfaces/cat.interface.ts
export interface Cat {
  name: string;
  age: number;
  breed: string;
}

// cats.service.ts
import { Injectable } from "@nestjs/common";
import { Cat } from "./interfaces/cat.interface";

@Injectable()
export class CatsService {
  private readonly cats: Cat[] = [];

  create(cat: Cat) {
    this.cats.push(cat);
  }

  findAll(): Cat[] {
    return this.cats;
  }
}
```

> 要使用 CLI 创建服务类，只需执行 `nest g service cats` 命令。

### controller 中注入使用

```ts
import { Controller, Get, Post, Body } from "@nestjs/common";
import { CreateCatDto } from "./dto/create-cat.dto";
import { CatsService } from "./cats.service";
import { Cat } from "./interfaces/cat.interface";

@Controller("cats")
export class CatsController {
  constructor(private catsService: CatsService) {}

  @Post()
  async create(@Body() createCatDto: CreateCatDto) {
    this.catsService.create(createCatDto);
  }

  @Get()
  async findAll(): Promise<Cat[]> {
    return this.catsService.findAll();
  }
}
```

### 基于属性的注入

```ts
import { Injectable, Inject } from "@nestjs/common";

@Injectable()
export class HttpService<T> {
  @Inject("HTTP_OPTIONS")
  private readonly httpClient: T;
}
```

### 注册提供者/服务

```ts
import { Module } from "@nestjs/common";
import { CatsController } from "./cats/cats.controller";
import { CatsService } from "./cats/cats.service";

@Module({
  controllers: [CatsController],
  providers: [CatsService],
})
export class AppModule {}
```

### 目录结构

```bash
src
├── cats
│    ├──dto
│    │   └──create-cat.dto.ts
│    ├── interfaces
│    │       └──cat.interface.ts
│    ├──cats.service.ts
│    └──cats.controller.ts
├──app.module.ts
└──main.ts
```

## 模块

> 模块是具有 @Module() 装饰器的类。 @Module() 装饰器提供了元数据，Nest 用它来组织应用程序结构。

![模块](http://cdn.mydearest.cn/blog/images/nest-module.png)

@module() 装饰器接受一个描述模块属性的对象：

- providers 由 Nest 注入器实例化的提供者，并且可以至少在整个模块中共享
- controllers 必须创建的一组控制器
- imports 导入模块的列表，这些模块导出了此模块中所需提供者
- exports 由本模块提供并应在其他模块中可用的提供者的子集。

### 细分功能模块

```ts
// cats/cats.module.ts
import { Module } from "@nestjs/common";
import { CatsController } from "./cats.controller";
import { CatsService } from "./cats.service";

@Module({
  controllers: [CatsController],
  providers: [CatsService],
})
export class CatsModule {}
```

> 要使用 CLI 创建模块，只需执行 `nest g module cats` 命令。

- 导入到根模块

```ts
import { Module } from "@nestjs/common";
import { CatsModule } from "./cats/cats.module";

@Module({
  imports: [CatsModule],
})
export class ApplicationModule {}
```

### 目录结构

```bash
src
├──cats
│    ├──dto
│    │   └──create-cat.dto.ts
│    ├──interfaces
│    │     └──cat.interface.ts
│    ├─cats.service.ts
│    ├─cats.controller.ts
│    └──cats.module.ts
├──app.module.ts
└──main.ts
```

### 共享模块

在 Nest 中，默认情况下，模块是单例，因此您可以轻松地在多个模块之间共享同一个提供者实例。
![共享模块](http://cdn.mydearest.cn/blog/images/nest-shared.png)

```ts
// cats.module.ts
import { Module } from "@nestjs/common";
import { CatsController } from "./cats.controller";
import { CatsService } from "./cats.service";

@Module({
  controllers: [CatsController],
  providers: [CatsService],
  exports: [CatsService],
})
export class CatsModule {}
```

> 现在，每个导入 CatsModule 的模块都可以访问 CatsService ，并且它们将共享相同的 CatsService 实例。

### 模块导出

```ts
@Module({
  imports: [CommonModule],
  exports: [CommonModule],
})
export class CoreModule {}
```

### 依赖注入

```ts
import { Module } from "@nestjs/common";
import { CatsController } from "./cats.controller";
import { CatsService } from "./cats.service";

@Module({
  controllers: [CatsController],
  providers: [CatsService],
})
export class CatsModule {
  constructor(private readonly catsService: CatsService) {}
}
```

> 但是，由于循环依赖性，模块类不能注入到提供者中。

### 全局模块

```ts
import { Module, Global } from "@nestjs/common";
import { CatsController } from "./cats.controller";
import { CatsService } from "./cats.service";

@Global()
@Module({
  controllers: [CatsController],
  providers: [CatsService],
  exports: [CatsService],
})
export class CatsModule {}
```

@Global 装饰器使模块成为全局作用域。 全局模块应该只注册一次，最好由根或核心模块注册。 在上面的例子中，CatsService 组件将无处不在，
而想要使用 CatsService 的模块则不需要在 imports 数组中导入 CatsModule。

> 使一切全局化并不是一个好的解决方案。 全局模块可用于减少必要模板文件的数量。 imports 数组仍然是使模块 API 透明的最佳方式。

### 动态模块

```ts
import { Module, DynamicModule } from "@nestjs/common";
import { createDatabaseProviders } from "./database.providers";
import { Connection } from "./connection.provider";

@Module({
  providers: [Connection],
})
export class DatabaseModule {
  // forRoot() 可以同步或异步（Promise）返回动态模块。
  static forRoot(entities = [], options?): DynamicModule {
    const providers = createDatabaseProviders(options, entities);
    return {
      // global: true,
      module: DatabaseModule,
      providers: providers,
      exports: providers,
    };
  }
}
```

```ts
import { Module } from "@nestjs/common";
import { DatabaseModule } from "./database/database.module";
import { User } from "./users/entities/user.entity";

@Module({
  imports: [DatabaseModule.forRoot([User])],
  exports: [DatabaseModule], // 省略forRoot方法的调用
})
export class AppModule {}
```

## 中间件

> 中间件是在路由处理程序之前调用的函数。中间件函数可以访问请求和响应对象，以及应用程序请求响应周期中的 `next()` 中间件函数。next()
> 中间件函数通常由名为 next 的变量表示。

![中间件](http://cdn.mydearest.cn/blog/images/nest-middleware.png)

> Nest 中间件实际上等价于 express 中间件。

- 中间件函数可以执行以下任务:

1. 执行任何代码。
2. 对请求和响应对象进行更改。
3. 结束请求-响应周期。
4. 调用堆栈中的下一个中间件函数。
5. 如果当前的中间件函数没有结束请求-响应周期, 它必须调用 next() 将控制传递给下一个中间件函数。否则, 请求将被挂起。

### 实现一个简单的日志中间件

```ts
import { Injectable, NestMiddleware } from "@nestjs/common";
import { Request, Response } from "express";

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: Function) {
    console.log("Request...");
    next();
  }
}
```

### 依赖注入

Nest 中间件完全支持依赖注入。 就像提供者和控制器一样，它们能够注入属于同一模块的依赖项（通过 constructor ）。

### 应用中间件

中间件不能在 @Module() 装饰器中列出。我们必须使用模块类的 configure() 方法来设置它们。包含中间件的模块必须实现 NestModule 接
口。我们将 LoggerMiddleware 设置在 ApplicationModule 层上。

```ts
// app.module.ts
import {
  Module,
  NestModule,
  RequestMethod,
  MiddlewareConsumer,
} from "@nestjs/common";
import { LoggerMiddleware } from "./common/middleware/logger.middleware";
import { CatsModule } from "./cats/cats.module";

@Module({
  imports: [CatsModule],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes("cats");
    // 限制为特定方法
    // .forRoutes({ path: 'cats', method: RequestMethod.GET });
    // MiddlewareConsumer 中间件消费者
    // 要排除的路由
    // .exclude(
    //   { path: 'cats', method: RequestMethod.GET },
    //   { path: 'cats', method: RequestMethod.POST },
    //   'cats/(.*)',
    // )
    // .forRoutes(CatsController);
  }
}
```

### 函数式中间件

我们使用的 LoggerMiddleware 类非常简单。它没有成员，没有额外的方法，没有依赖关系。为什么我们不能只使用一个简单的函数？

> 中间件没有任何依赖关系时，我们可以考虑使用函数式中间件。

```ts
// logger.middleware.ts改成
export function logger(req, res, next) {
  console.log(`Request...`);
  next();
}

// 使用
consumer.apply(logger).forRoutes(CatsController);
```

### 多个中间件

```ts
consumer.apply(cors(), helmet(), logger).forRoutes(CatsController);
```

### 全局中间件

```ts
// INestApplication实例提供的 use()方法
const app = await NestFactory.create(AppModule);
app.use(logger);
await app.listen(3000);
```

## 异常过滤器

> 内置的异常层负责处理整个应用程序中的所有抛出的异常。当捕获到未处理的异常时，最终用户将收到友好的响应。

![异常过滤器](http://cdn.mydearest.cn/blog/images/nest-filter.png)

此操作由内置的全局异常过滤器执行，该过滤器处理类型 HttpException（及其子类）的异常。每个发生的异常都由全局异常过滤器处理, 当这个异
常无法被识别时 (既不是 HttpException 也不是继承的类 HttpException ) , 用户将收到以下 JSON 响应

```ts
{
  "statusCode": 500,
  "message": "Internal server error"
}
```

### 基础异常类 HttpException

```ts
@Get()
async findAll() {
  throw new HttpException('Forbidden', HttpStatus.FORBIDDEN);
  // throw new HttpException({
  //   status: HttpStatus.FORBIDDEN,
  //   error: 'This is a custom message',
  // }, HttpStatus.FORBIDDEN);
}

// {
//   "status": 403,
//   "error": "This is a custom message"
// }
```

### 自定义异常

```ts
export class ForbiddenException extends HttpException {
  constructor() {
    super('Forbidden', HttpStatus.FORBIDDEN);
  }
}

// 使用
@Get()
async findAll() {
  throw new ForbiddenException();
}
```

### 内置 HTTP 异常

Nest 提供了一系列继承自核心异常 HttpException 的可用异常。

- BadRequestException
- UnauthorizedException
- NotFoundException
- ForbiddenException
- NotAcceptableException
- RequestTimeoutException
- ConflictException
- GoneException
- PayloadTooLargeException
- UnsupportedMediaTypeException
- UnprocessableException
- InternalServerErrorException
- NotImplementedException
- BadGatewayException
- ServiceUnavailableException
- GatewayTimeoutException

### 异常过滤器

```ts
// http-exception.filter.ts
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
} from "@nestjs/common";
import { Request, Response } from "express";

// @Catch() 装饰器绑定所需的元数据到异常过滤器上。它告诉 Nest这个特定的过滤器正在寻找 HttpException 而不是其他的。
// 在实践中，@Catch() 可以传递多个参数，所以你可以通过逗号分隔来为多个类型的异常设置过滤器。
@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    // ArgumentsHost参数主机是一个功能强大的实用程序对象  来获取所需的 Request 和 Response 对象
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status = exception.getStatus();

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

> 所有异常过滤器都应该实现通用的 ExceptionFilter<T> 接口。它需要你使用有效签名提供 catch(exception: T, host:
> ArgumentsHost)方法。T 表示异常的类型。

### 绑定过滤器

```ts
// cats.controller.ts
@Post()
@UseFilters(new HttpExceptionFilter())
async create(@Body() createCatDto: CreateCatDto) {
  throw new ForbiddenException();
}

@Post()
// 也可以不实例化
@UseFilters(HttpExceptionFilter)
async create(@Body() createCatDto: CreateCatDto) {
  throw new ForbiddenException();
}

// 作用于整个controller
@UseFilters(new HttpExceptionFilter())
export class CatsController {}
```

> 尽可能使用类而不是实例。由于 Nest 可以轻松地在整个模块中重复使用同一类的实例，因此可以减少内存使用。

### 全局过滤器

```ts
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalFilters(new HttpExceptionFilter());
  await app.listen(3000);
}
bootstrap();
```

```ts
// 模块设置过滤器
import { Module } from "@nestjs/common";
import { APP_FILTER } from "@nestjs/core";

@Module({
  providers: [
    {
      provide: APP_FILTER,
      useClass: HttpExceptionFilter,
    },
  ],
})
export class AppModule {}
```

### 捕获异常

```ts
// any-exception.filter.ts
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from "@nestjs/common";

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

## 管道

> 管道是具有 @Injectable() 装饰器的类。管道应实现 PipeTransform 接口。
> ![异常过滤器](http://cdn.mydearest.cn/blog/images/nest-filter.png)

管道有两个类型:

- 转换：管道将输入数据转换为所需的数据输出
- 验证：对输入数据进行验证，如果验证成功继续传递; 验证失败则抛出异常;

### 内置管道

- ValidationPipe
- ParseIntPipe
- ParseBoolPipe
- ParseArrayPipe
- ParseUUIDPipe
- DefaultValuePipe

```ts
// ValidationPipe
import { PipeTransform, Injectable, ArgumentMetadata } from "@nestjs/common";

@Injectable()
export class ValidationPipe implements PipeTransform {
  // 参数 value和metadata元数据
  transform(value: any, metadata: ArgumentMetadata) {
    return value;
  }
}
// PipeTransform<T, R> 是一个通用接口，其中 T 表示 value 的类型，R 表示 transform() 方法的返回类型。
```

```ts
export interface ArgumentMetadata {
  type: "body" | "query" | "param" | "custom";
  metatype?: Type<unknown>;
  data?: string;
}
```

### 验证管道

```ts
import {
  PipeTransform,
  Injectable,
  ArgumentMetadata,
  BadRequestException,
} from "@nestjs/common";
import { ObjectSchema } from "@hapi/joi";

@Injectable()
export class JoiValidationPipe implements PipeTransform {
  constructor(private schema: ObjectSchema) {}
  // 要么返回该值，要么抛出一个错误
  transform(value: any, metadata: ArgumentMetadata) {
    const { error } = this.schema.validate(value);
    if (error) {
      throw new BadRequestException("Validation failed");
    }
    return value;
  }
}
```

### 绑定管道 UsePipes

```ts
@Post()
@UsePipes(new JoiValidationPipe(createCatSchema))
async create(@Body() createCatDto: CreateCatDto) {
  this.catsService.create(createCatDto);
}

// 全局
app.useGlobalPipes(new ValidationPipe());

// 模块
import { Module } from '@nestjs/common';
import { APP_PIPE } from '@nestjs/core';

@Module({
  providers: [
    {
      provide: APP_PIPE,
      useClass: ValidationPipe
    }
  ]
})
export class AppModule {}
```

### 类验证修饰符

```ts
import { IsString, IsInt } from "class-validator";

export class CreateCatDto {
  @IsString()
  name: string;

  @IsInt()
  age: number;

  @IsString()
  breed: string;
}
```

## 守卫

> 守卫是一个使用 @Injectable() 装饰器的类。 守卫应该实现 CanActivate 接口。

![守卫](http://cdn.mydearest.cn/blog/images/nest-guard.png)

守卫有一个单独的责任。它们根据运行时出现的某些条件（例如权限，角色，访问控制列表等）来确定给定的请求是否由路由处理程序处理。 这通常称为
授权。

- 守卫在中间件之后执行，但是在任何拦截器和管道之前执行。

### 授权守卫

授权是保护的一个很好的用例，因为只有当调用者(通常是经过身份验证的特定用户)具有足够的权限时，特定的路由才可用。我们现在要构建的
AuthGuard 假设用户是经过身份验证的(因此，请求头附加了一个 token)。它将提取和验证 token，并使用提取的信息来确定请求是否可以继续。

```ts
// auth.guard.ts
import { Injectable, CanActivate, ExecutionContext } from "@nestjs/common";
import { Observable } from "rxjs";

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(
    context: ExecutionContext
  ): boolean | Promise<boolean> | Observable<boolean> {
    // 执行上下文扩展了参数主机 获取request对象
    const request = context.switchToHttp().getRequest();
    return validateRequest(request);
  }
}

// export interface ExecutionContext extends ArgumentsHost {
//   getClass<T = any>(): Type<T>;
//   getHandler(): Function;
// }
```

### 角色守卫

这个守卫只允许具有特定角色的用户访问。

### 绑定守卫

```ts
// 同理 装饰器 全局绑定 模块绑定
@UseGuards(RolesGuard)

app.useGlobalGuards(new RolesGuard());


import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';

@Module({
  providers: [
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
  ],
})
export class AppModule {}
```

### 反射器

```ts
// 设置元数据
@Post()
@SetMetadata('roles', ['admin'])
async create(@Body() createCatDto: CreateCatDto) {
  this.catsService.create(createCatDto);
}

// 也可以设置装饰器
roles.decorator.ts
import { SetMetadata } from '@nestjs/common';

export const Roles = (...roles: string[]) => SetMetadata('roles', roles);

// 使用
@Roles("admin")

// 取值
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.get<string[]>('roles', context.getHandler());
    if (!roles) {
      return true;
    }
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    return matchRoles(roles, user.roles);
  }
}
```

## 拦截器

拦截器是使用 `@Injectable()` 装饰器注解的类。拦截器应该实现 `NestInterceptor` 接口。

![拦截器](http://cdn.mydearest.cn/blog/images/nest-interceptor.png)

功能有：

- 在函数执行之前/之后绑定额外的逻辑
- 转换从函数返回的结果
- 转换从函数抛出的异常
- 扩展基本函数行为
- 根据所选条件完全重写函数 (例如, 缓存目的)

### 概念

每个拦截器都有 intercept() 方法，它接收 2 个参数。

- 第一个是 ExecutionContext 实例（与守卫完全相同的对象）。 ExecutionContext 继
  承自 ArgumentsHost 。 ArgumentsHost 是传递给原始处理程序的参数的一个包装 ，它根据应用程序的类型包含不同的参数数组。

- 第二个参数是 CallHandler。如果不手动调用 handle() 方法，则主处理程序根本不会进行求值。这是什么意思？基本上，CallHandler 是一个
  包装执行流的对象，因此推迟了最终的处理程序执行。

### 截取切面

```ts
// logging.interceptor.ts
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from "@nestjs/common";
import { Observable, of } from "rxjs";
import { tap } from "rxjs/operators";

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    console.log("Before...");

    const now = Date.now();
    return next.handle().pipe(
      tap(() => console.log(`After... ${Date.now() - now}ms`))
      // map(data => ({ data })) 响应映射
      // catchError(err => throwError(new BadGatewayException()) 异常映射
    );

    // stearm
    // const isCached = true;
    // if (isCached) {
    //   return of([]);
    // }
    // return next.handle();
  }
}
```

### 绑定拦截器

```ts
// 装饰器
@UseInterceptors(new LoggingInterceptor())

// 全局
app.useGlobalInterceptors(new LoggingInterceptor());

// 模块
import { Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';

@Module({
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: LoggingInterceptor,
    },
  ],
})
export class AppModule {}
```

## 自定义装饰器

```ts
// user.decorator.ts
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const User = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);

// 使用传递数据
@Get()
async findOne(@User("name") user: UserEntity) {
  console.log(user);
}
```

### 使用管道

```ts
@Get()
async findOne(@User(new ValidationPipe()) user: UserEntity) {
  console.log(user);
}
```

### 多个装饰器

```ts
import { applyDecorators } from '@nestjs/common';

export function Auth(...roles: Role[]) {
  return applyDecorators(
    SetMetadata('roles', roles),
    UseGuards(AuthGuard, RolesGuard),
    ApiBearerAuth(),
    ApiUnauthorizedResponse({ description: 'Unauthorized"' }),
  );
}

// 使用
@Get('users')
@Auth('admin')
findAllUsers() {}
```

结束 🔚，有时间再介绍下`GraphQL`。
