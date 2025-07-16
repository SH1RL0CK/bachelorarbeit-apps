import { Tabs } from "expo-router";
import React from "react";
import { Platform } from "react-native";
import { Icon, useTheme } from "react-native-paper";

export default function TabLayout() {
    const theme = useTheme();

    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: theme.colors.primary,
                tabBarInactiveTintColor: theme.colors.onSurfaceVariant,
                headerShown: false,
                tabBarStyle: {
                    backgroundColor: theme.colors.surface,
                    borderTopColor: theme.colors.outline,
                    borderTopWidth: 1,
                    ...Platform.select({
                        ios: {
                            position: "absolute",
                        },
                        default: {},
                    }),
                },
            }}
        >
            <Tabs.Screen
                name="index"
                options={{
                    title: "Zitate",
                    tabBarIcon: ({ color, size }) => (
                        <Icon
                            source="format-quote-close"
                            size={size}
                            color={color}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="random-quote"
                options={{
                    title: "Zufällig",
                    tabBarIcon: ({ color, size }) => (
                        <Icon source="movie-open" size={size} color={color} />
                    ),
                }}
            />
        </Tabs>
    );
}
