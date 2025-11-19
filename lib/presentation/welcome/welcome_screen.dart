import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          //tiled bg
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                AppAssets.dotPattern,
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
          ),

          //Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //top
                  const Spacer(flex: 2),

                  //logo and text
                  Column(
                    children: [
                      //logo
                      Image.asset(
                        AppAssets.logo,
                        width: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 32),

                      //Title
                      Text(
                        AppStrings.welcomeTitle,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      //Subtitle
                      Text(
                        AppStrings.welcomeSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const Spacer (flex: 3),

                  //Buttons
                  Column(
                    children: [
                      //Get Started
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //context.go('/register');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text ('Register screen'),
                              ),
                            );
                          },
                          child: const Text(AppStrings.getStarted),
                        ),
                      ),
                      const SizedBox(height: 16),

                      //Login Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAcc,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: (){
                              //context.go('/login');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login next'),
                                ),
                              );
                            },
                            child: const Text(AppStrings.login),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}