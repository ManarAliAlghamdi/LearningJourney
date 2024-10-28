//import SwiftUI
//
//struct AddNewRecipes: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var showIngredientPopup = false // State to control popup visibility
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading, spacing: 20) {
//                // Header Section
//                HStack {
//                    Text("    New Recipes")
//                        .font(.title)
//                        .bold()
//                    Spacer().frame(height: 10)
//                }
//                .frame(height: 80)
//                .background(Color(.systemGray6))
//
//                // Image upload area
//                VStack {
//                    Image(systemName: "photo.badge.plus")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 90, height: 90)
//                        .foregroundColor(myColors.AppOrange)
//
//                    Text("Upload Photo")
//                        .padding(.top, -15)
//                        .font(.system(size: 25, weight: .bold))
//                }
//                .frame(maxWidth: .infinity, minHeight: 150)
//                .padding()
//                .background(Color(.systemGray5))
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(myColors.AppOrange, style: StrokeStyle(lineWidth: 2, dash: [5]))
//                )
//                .padding(.vertical)
//
//                // Title input
//                Text("Title")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .padding(.horizontal)
//
//                TextField("Title", text: .constant(""))
//                    .padding()
//                    .background(Color(.systemGray5))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//
//                // Description input
//                Text("Description")
//                    .font(.headline)
//                    .padding(.horizontal)
//                    .fontWeight(.bold)
//
//                TextField("Description", text: .constant(""))
//                    .frame(alignment: .leading)
//                    .padding()
//                    .frame(width: 367, height: 130, alignment: .topLeading)
//                    .background(Color(.systemGray5))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//
//                // Add Ingredients section
//                HStack {
//                    Text("Add Ingredient")
//                        .font(.headline)
//                    Spacer()
//                    Button(action: {
//                        showIngredientPopup.toggle() // Show popup when button is tapped
//                    }) {
//                        Image(systemName: "plus")
//                            .font(.system(size: 22, weight: .bold))
//                            .foregroundColor(myColors.AppOrange)
//                    }
//                }
//                .padding(.horizontal)
//
//                Spacer()
//            }
//            .navigationBarItems(
//                leading: Button("Back") {
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .foregroundColor(myColors.AppOrange),
//                trailing: Button("Save") {
//                    // Action to save the recipe
//                }
//                .foregroundColor(myColors.AppOrange)
//            )
//        }
//        .overlay(
//            showIngredientPopup ? Color.black.opacity(0.4).edgesIgnoringSafeArea(.all) : nil // Dimmed background when the popup is shown
//        )
//        .overlay(
//            // Show the popup view when showIngredientPopup is true
//            showIngredientPopup ? AddIngredientView2(isPresented: $showIngredientPopup)
//                .frame(width: 306, height: 382)
//                .background(Color.white)
//                .cornerRadius(15)
//                .shadow(radius: 10)
//                : nil
//        )
//    }
//}
//
//
//struct AddIngredientView2: View {
//    @Binding var isPresented: Bool
//    @State private var ingredientName = ""
//    @State private var measurement = "Spoon"
//    @State private var servingCount = 1
//    let measurements = ["Spoon", "Cup"]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Ingredient Name Input
//            Text("Ingredient Name")
//                .font(.headline)
//                .bold()
//            TextField("Ingredient Name", text: $ingredientName)
//                .padding(10)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//            
//            // Measurement Selection
//            Text("Measurement")
//                .font(.headline)
//                .bold()
//            HStack(spacing: 8) {
//                ForEach(measurements, id: \.self) { measure in
//                    Button(action: {
//                        measurement = measure
//                    }) {
//                        HStack {
//                            Image(systemName: measure == "Spoon" ? "fork.knife" : "cup.and.saucer")
//                            Text(measure)
//                        }
//                        .padding(8)
//                        .frame(maxWidth: .infinity)
//                        .background(measurement == measure ? Color(myColors.AppOrange) : Color(.systemGray4))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                    }
//                }
//            }
//            
//            // Serving Section with Label and Stepper in the same row
//            HStack {
////                Text("Serving")
////                    .font(.headline)
////                    .bold()
//                
//                HStack(spacing: 4) {
//                    Button(action: {
//                        if servingCount > 1 {
//                            servingCount -= 1
//                        }
//                    }) {
//                        Image(systemName: "minus.circle")
//                            .font(.system(size: 24))
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Text("\(servingCount)")
//                        .font(.title3)
//                        .frame(minWidth: 30)
//                        .padding(.horizontal, 8)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                    
//                    Button(action: {
//                        servingCount += 1
//                    }) {
//                        Image(systemName: "plus.circle")
//                            .font(.system(size: 24))
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding(8)
//                .background(Color(.systemGray5))
//                .cornerRadius(8)
//                
//                HStack {
//                    Image(systemName: measurement == "Spoon" ? "fork.knife" : "cup.and.saucer")
//                    Text(measurement)
//                }
//                .padding(8)
//                .frame(maxWidth: .infinity)
//                .background(measurement == measure ? Color(myColors.AppOrange) : Color(.systemGray4))
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//
//            Spacer()
//            
//            // Cancel and Add buttons
//            HStack(spacing: 16) {
//                Button(action: {
//                    isPresented = false // Dismiss the popup
//                }) {
//                    Text("Cancel")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color(.systemGray4))
//                        .foregroundColor(.red)
//                        .cornerRadius(8)
//                }
//                
//                Button(action: {
//                    // Action to add the ingredient
//                    isPresented = false // Dismiss the popup
//                }) {
//                    Text("Add")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color(myColors.AppOrange))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//            }
//            .padding(.horizontal)
//        }
//        .padding()
//        .frame(width: 300, height: 400, alignment: .center)
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 4)
//        .overlay(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
//        )
//        .padding() // Additional padding to ensure the popup fits correctly
//    }
//}
//
