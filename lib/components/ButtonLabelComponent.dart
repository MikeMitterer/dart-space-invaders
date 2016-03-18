/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
     
part of spaceinvaders.components;

/* 
/// Basic DI configuration for [ButtonLabelComponent]
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new ButtonLabelComponentModule());
///         }     
///     }
class ButtonLabelComponentModule  extends di.Module {
    ButtonLabelComponentModule() {
        // bind(DeviceProxy);
        
        // -- services
        // bind(SignalService, toImplementation: SignalServiceImpl);
    }
} 
*/

/// Controller-View for <mdlx-button-label></mdlx-button-label>
///
@MdlComponentModel
class ButtonLabelComponent extends MdlComponent {
    final Logger _logger = new Logger('spaceinvaders.components.ButtonLabelComponent');

    //static const _ButtonLabelComponentConstant _constant = const _ButtonLabelComponentConstant();
    static const _ButtonLabelComponentCssClasses _cssClasses = const _ButtonLabelComponentCssClasses();

    final SpaceInvadersStore _store;

    ButtonLabelComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _store = injector.get(SpaceInvadersStore), super(element,injector) {
        
        _init();
        
    }
    
    static ButtonLabelComponent widget(final dom.HtmlElement element) => mdlComponent(element,ButtonLabelComponent) as ButtonLabelComponent;
    
    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("ButtonLabelComponent - init");
        
        // Recommended - add SELECTOR as class if this component is a TAG!
        element.classes.add(_ButtonLabelComponentConstant.WIDGET_SELECTOR);
        
        _bindStoreActions();

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// After the template is rendered we bind all the necessary Actions for this component
    void _bindStoreActions() {
        // only after creation...
        if(_store == null) { return;}

        _store.onChange.listen((final DataStoreChangedEvent event) {

            // Handle specific Update-Actions
            // if(event.data.actionname == UpdateTimeView.NAME) {
            //
            // }

            _updateView();

        });
    }

    /// Something has changed in the attached store - visualize it
    ///
    /// Usually this function is called if we get an onChange-event from our store
    void _updateView() {
        element.text = _store.hasStarted ? "Press to Stop" : "Press to Start";
    }
}

/// Registers the ButtonLabelComponent-Component
///
///     main() {
///         registerButtonLabelComponent();
///         ...
///     }
///
void registerButtonLabelComponent() {
    final MdlConfig config = new MdlWidgetConfig<ButtonLabelComponent>(
        _ButtonLabelComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new ButtonLabelComponent.fromElement(element,injector)
    );
    
    // If you want <mdlx-button-label></mdlx-button-label> set selectorType to SelectorType.TAG.
    // If you want <div mdlx-button-label></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdlx-button-label"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ButtonLabelComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _ButtonLabelComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _ButtonLabelComponentConstant {

    static const String WIDGET_SELECTOR = "mdlx-button-label";

    const _ButtonLabelComponentConstant();
}  