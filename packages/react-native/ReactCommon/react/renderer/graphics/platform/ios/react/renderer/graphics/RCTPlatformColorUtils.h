/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#import <UIKit/UIKit.h>
#import <vector>

namespace facebook::react {
struct ColorComponents;
struct Color;
} // namespace facebook::react

facebook::react::ColorComponents RCTPlatformColorComponentsFromSemanticItems(
    std::vector<std::string>& semanticItems);
UIColor* RCTPlatformColorFromSemanticItems(
    std::vector<std::string>& semanticItems);
UIColor* RCTPlatformColorFromColor(const facebook::react::Color& color);
