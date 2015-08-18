> Scopes and Contexts
Added by Steven Gong, last edited by blah on Mar 10, 2009  (view change)
Labels:
scope, context


Add Labels

Wait Image
Enter labels to add to this page:
Tip: Looking for a label? Just start typing.


Overview

This page explains Scope and Context in Red5. The Scope model in Red5 that supports Application model is an extension to the Application model in FMS. The Context model in Red5 has no counterpart in FMS. These two concepts are Red5 specific.
Concept of Scope

Resources are managed in Red5 in a tree. Each node of a tree is called a scope. If the scope is a leaf node, it is called a BasicScope and if the scope contains child scopes, it is called a Scope. There're two pre-defined BasicScopes in Red5, SharedObject Scope and BroadcastStream Scope.

Each Application has its own Scope hierarchy and the root scope is WebScope. There's a global scope defined in Red5 that aims to provide common resource sharing across Applications namely GlobalScope. The GlobalScope is the parent of all WebScopes. Other scopes in between are all instances of Scope. Each scope takes a name. The GlobalScope is named "default". The WebScope is named per Application context name. The Scope is named per path name. The SharedObject Scope is named per SharedObject's name. The BroadcastStream Scope is named per Stream's name.

Except GlobalScope and BasicScopes, all Scopes can be connected by a client. A Scope object might be created as a result of a connection request from a client. For example, a client could issue a request to connect to oflaDemo/room0 when the room0 scope does not exist. After the establishment of the connection, room0 is created. If the url contains many intermediate scopes, all these scopes will be created. For example, oflaDemo/lobby0/room0 is requested and neither lobby0 or room0 exist. lobby0 and room0 will be created accordingly. Then the connection is tied to room0 scope.

A typical scope hierarchy could be like this:

GlobalScope(default) --> WebScope(oflaDemo) --> Scope(room0) --> BroadcastStream(live0), SharedObject(so1)
> --> Scope(room1) --> SharedObject(so0)
> --> WebScope(fitcDemo) --> Scope(room1) --> BroadcastStream(live0)

For standalone version, the global scope object is defined in webapps/red5-default.xml. For WAR version, the global scope object is defined together with web scope object in conf/war/applicationContext.xml.
Scope Functionality

Apart from the tree structure iteration, Scope provides the resource resolving and service registration capabilities. It also manages a set of connection objects that are currently connected to it. A ScopeHandler can be injected into a Scope so that the activity of Scope can be monitored, including the creation, destruction and connection of Scope.
Context

A Context is stuck to a Scope object and provides additional services to the scope object. Context objects can be obtained by calling IScope.getScope(). Context wraps the spring application context so that the services can be declared as spring beans and looked up from Context. Other services include "clientRegistry", "serviceInvoker", "persistenceStore", "mappingStrategy" and resource resolver that backs the resource resolver provided in Scope. For more information of Context, please refer to org.red5.server.api.IContext.

Context can be inherited. This means a Scope may not define a context and instead use its parent's context directly. Only GlobalScope and WebScope use their own Context object.