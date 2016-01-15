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
 
/// Basic DI configuration for [ArcadeButtonComponent]
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new ArcadeButtonComponentModule());
///         }     
///     }
class ArcadeButtonComponentModule  extends di.Module {
    ArcadeButtonComponentModule() {
        // bind(DeviceProxy);
        
        // -- services
        // bind(SignalService, toImplementation: SignalServiceImpl);
    }
} 

/// Controller for <div class="mdlx-arcade-button"></div>
///
class ArcadeButtonComponent extends MdlComponent {
    final Logger _logger = new Logger('spaceinvaders.components.ArcadeButtonComponent');

    //static const _ArcadeButtonComponentConstant _constant = const _ArcadeButtonComponentConstant();
    static const _ArcadeButtonComponentCssClasses _cssClasses = const _ArcadeButtonComponentCssClasses();

    ArcadeButtonComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        
        _init();
        
    }
    
    static ArcadeButtonComponent widget(final dom.HtmlElement element) => mdlComponent(element,ArcadeButtonComponent) as ArcadeButtonComponent;
    
    // Central Element - by default this is where mdlx-arcade-button can be found (element)
    // html.Element get hub => inputElement;
    
    // - EventHandler -----------------------------------------------------------------------------

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("ArcadeButtonComponent - init");

        // Recommended - add SELECTOR as class if this component is a TAG!
        // element.classes.add(_ArcadeButtonComponentConstant.WIDGET_SELECTOR);

        final dom.DivElement knob = new dom.DivElement();
        knob.classes.add(_cssClasses.KNOB);
        element.append(knob);
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// Registers the ArcadeButtonComponent-Component
///
///     main() {
///         registerArcadeButtonComponent();
///         ...
///     }
///
void registerArcadeButtonComponent() {
    final MdlConfig config = new MdlWidgetConfig<ArcadeButtonComponent>(
        _ArcadeButtonComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new ArcadeButtonComponent.fromElement(element,injector)
    );
    
    // If you want <mdlx-arcade-button></mdlx-arcade-button> set selectorType to SelectorType.TAG.
    // If you want <div mdlx-arcade-button></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdlx-arcade-button"></div>)
    config.selectorType = SelectorType.CLASS;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ArcadeButtonComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    final String KNOB = "mdlx-arcade-button__knob";

    const _ArcadeButtonComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _ArcadeButtonComponentConstant {

    static const String WIDGET_SELECTOR = "mdlx-arcade-button";

    const _ArcadeButtonComponentConstant();
}  