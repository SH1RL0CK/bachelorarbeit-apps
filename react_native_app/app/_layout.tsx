import { useFonts } from "expo-font";
import { Stack } from "expo-router";
import { MD3DarkTheme, MD3LightTheme, PaperProvider } from "react-native-paper";
import "react-native-reanimated";

import { useColorScheme } from "@/hooks/useColorScheme";
import React from "react";
import { Platform } from "react-native";

export default function RootLayout() {
    const colorScheme = useColorScheme();
    const [loaded] = useFonts({
        SpaceMono: require("../assets/fonts/SpaceMono-Regular.ttf"),
    });

    if (!loaded) {
        // Async font loading only occurs in development.
        return null;
    }

    return (
        <PaperProvider
            theme={colorScheme === "dark" ? MD3DarkTheme : MD3LightTheme}
        >
            <React.Fragment>
                {Platform.OS === "web" ? (
                    <style type="text/css">
                        {`
                                @font-face {
                                font-family: 'MaterialDesignIcons';
                                src: url(${require("@react-native-vector-icons/material-design-icons/fonts/MaterialDesignIcons.ttf")}) format('truetype');
                            }
                            `}
                    </style>
                ) : null}
                <Stack>
                    <Stack.Screen
                        name="(tabs)"
                        options={{ headerShown: false }}
                    />
                    <Stack.Screen
                        name="quote-detail"
                        options={{ headerShown: false }}
                    />
                    <Stack.Screen name="+not-found" />
                </Stack>
            </React.Fragment>
        </PaperProvider>
    );
}
