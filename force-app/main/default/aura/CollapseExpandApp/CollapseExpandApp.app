<aura:application >
    <c:CollapseExpandCmp header="Collapse Exapand Aura Component"> 

        <aura:set attribute="body">
            
            <ui:message title="Aura Component Message" severity="confirm" closable="true">
                <p>The severity attribute indicates a message's severity level and determines the style to use when displaying the message. 
                    If the closable attribute is set to true, the message can be dismissed by pressing the × symbol. 
                    To apply Lightning Design System styling, we recommend that you use lightning:notificationsLibrary instead of ui:message.
                </p>
            </ui:message>
            
            <ui:message title="Severity Attributes" severity="info" closable="true">
                <p>The severity of the message. Possible values: message (default), confirm, info, warning, error</p>
            </ui:message>
            
            <ui:message title="Closable Attribute" severity="warning" closable="true">
                <p>Specifies whether to display an 'x' that will close the alert when clicked. Default value is 'false'.</p>
            </ui:message>
            
            <ui:message title="Body Attribute" severity="error" closable="true">
            <p>The body of the component. In markup, this is everything in the body of the tag.</p>
            </ui:message>
        </aura:set>
    </c:CollapseExpandCmp>
</aura:application>