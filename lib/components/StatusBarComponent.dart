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
/// Basic DI configuration for [StatusBarComponent]
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new StatusBarComponentModule());
///         }     
///     }
class StatusBarComponentModule  extends di.Module {
    StatusBarComponentModule() {
        // bind(DeviceProxy);
        
        // -- services
        // bind(SignalService, toImplementation: SignalServiceImpl);
    }
} 
*/

/// Controller-View for <mdlx-status-bar></mdlx-status-bar>
///
@MdlComponentModel
class StatusBarComponent extends MdlComponent {
    final Logger _logger = new Logger('spaceinvaders.components.StatusBarComponent');

    final int _MAX_TANKS = 3;

    //static const _StatusBarComponentConstant _constant = const _StatusBarComponentConstant();
    static const _StatusBarComponentCssClasses _cssClasses = const _StatusBarComponentCssClasses();

    final SpaceInvadersStore _store;

    StatusBarComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        :  _store = injector.get(SpaceInvadersStore), super(element,injector) {
        
        _init();
    }
    
    static StatusBarComponent widget(final dom.HtmlElement element) => mdlComponent(element,StatusBarComponent) as StatusBarComponent;
    
    // - EventHandler -----------------------------------------------------------------------------

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("StatusBarComponent - init");
        
        // Recommended - add SELECTOR as class if this component is a TAG!
        element.classes.add(_StatusBarComponentConstant.WIDGET_SELECTOR);

        final dom.DivElement tankContainer = new dom.DivElement();
        tankContainer.classes.add(_cssClasses.TANK_CONTAINER);
        element.append(tankContainer);

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
        dom.window.requestAnimationFrame( (_) {
            final dom.DivElement tankContainer = element.querySelector(".${_cssClasses.TANK_CONTAINER}");
            tankContainer.children.clear();
            for(int tanks = 0;tanks < _MAX_TANKS - _store.tanksLost;tanks++) {
                tankContainer.append(_createTank());
            }
        });
    }

    /// Creates a new Tank-Element (Sprite)
    dom.HtmlElement _createTank() {
        final dom.SpanElement tank = new dom.SpanElement();
        tank.classes.add(_cssClasses.TANK);
        tank.style.width = "22px";
        tank.style.height = "16px";
        tank.style.overflow = "hidden";


        final dom.ImageElement tankSprite = new dom.ImageElement(src: "packages/spaceinvaders/assets/images/invaders.png");
        tankSprite.style.left = "-62px";
        tankSprite.style.position = "relative";

        tank.append(tankSprite);

        return tank;
    }
}

/// Registers the StatusBarComponent-Component
///
///     main() {
///         registerStatusBarComponent();
///         ...
///     }
///
void registerStatusBarComponent() {
    final MdlConfig config = new MdlWidgetConfig<StatusBarComponent>(
        _StatusBarComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new StatusBarComponent.fromElement(element,injector)
    );
    
    // If you want <mdlx-status-bar></mdlx-status-bar> set selectorType to SelectorType.TAG.
    // If you want <div mdlx-status-bar></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdlx-status-bar"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _StatusBarComponentCssClasses {


    final String TANK_CONTAINER = "${_StatusBarComponentConstant.WIDGET_SELECTOR}__tank-container";
    final String TANK = "${_StatusBarComponentConstant.WIDGET_SELECTOR}__tank";

    final String IS_UPGRADED = 'is-upgraded';

    const _StatusBarComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _StatusBarComponentConstant {

    static const String WIDGET_SELECTOR = "mdlx-status-bar";

    const _StatusBarComponentConstant();
}  