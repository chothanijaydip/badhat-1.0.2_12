import 'package:badhat_b2b/ui/register/register_controller.dart';
import 'package:badhat_b2b/utils/contants.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class RegisterView extends WidgetView<RegisterScreen, RegisterScreenState> {
  RegisterView(RegisterScreenState state) : super(state);

  Widget firstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shop/Business Name*").paddingAll(4),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) return "Enter Business name";
            return null;
          },
          textInputAction: TextInputAction.done,
          controller: state.businessNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            //hintText: "Shop/Business Name*",
            ////helperText: "Shop/Business Name*",
          ),
        ).paddingAll(4),
        Text("Owner Name*").paddingAll(4),
        TextFormField(
          validator: (value) {
            if (value.isEmpty) return "Enter Owner name";
            return null;
          },
          textInputAction: TextInputAction.done,
          controller: state.ownerNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            //hintText: "Owner Name*",
            //helperText: "Owner Name*",
          ),
        ).paddingAll(4),
        Text("Select Your Business Type*").paddingAll(4),
        DropdownButtonFormField(
                validator: (value) {
                  if (value == null) return "Select Business type";
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //hintText: "You are a* ",
                  //helperText: "You are a* ",
                ),
                onChanged: (x) {
                  state.selectedBusinessType = x;
                },
                items: userType
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList())
            .paddingAll(4),
        Text("Select Your Business Category*").paddingAll(4),
        DropdownButtonFormField(
          validator: (value) {
            if (value == null) return "Select Business Domain";
            return null;
          },
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            //hintText: "Business Domain*",
            //helperText: "Business Domain*",
          ),
          onChanged: (category) {
            state.selectedCategory = category;
          },
          value: state.selectedCategory,
          items: state.categories
              .map((e) => DropdownMenuItem(
                    child: Text(
                      e.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: e.id.toString(),
                  ))
              .toList(),
        ).paddingAll(4),
        Text("Pincode*").paddingAll(4),
        TextFormField(
          validator: (value) {
            if (value.length != 6) return "Enter valid 6 digit pincode";
            return null;
          },
          keyboardType: TextInputType.numberWithOptions(signed: true),
          textInputAction: TextInputAction.done,
          controller: state.pincodeController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            //hintText: "Pincode*",
            //helperText: "Pincode*",
          ),
        ).paddingAll(4),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("State*").paddingAll(4),
                  DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) return "Select State";
                            return null;
                          },
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            //hintText: "State*",
                            //helperText: "State*",
                          ),
                          onChanged: (stateName) {
                            state.loadDistrict(stateName);
                          },
                          value: state.selectedState,
                          items: state.states
                              .map((e) => DropdownMenuItem(
                                    value: e.state,
                                    child: Text(
                                      e.state.trim(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList())
                      .paddingAll(4),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("District*").paddingAll(4),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) return "Select District";
                      return null;
                    },
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //hintText: "District*",
                      //helperText: "District*",
                    ),
                    onChanged: (district) {
                      state.updateSelectedDistrict(district);
                    },
                    value: state.selectedDistrict,
                    items: state.districts
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: e,
                            ))
                        .toList(),
                  ).paddingAll(4),
                ],
              ),
            )
          ],
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 18, top: 7),
          child: RaisedButton.icon(
            color: Colors.green,
            textColor: Colors.white,
            onPressed: () {
              if (state.formKey.currentState.validate()) {
                state.formKey.currentState.save();
                state.gotoSecondPage();
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
            label: Text("Next"),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: state.formKey,
            child: !state.isOnSecondage
                ? firstPage()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          child: Stack(
                            children: <Widget>[
                              state.avatar == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Center(
                                          child: Text(
                                        "Add store image",
                                        textAlign: TextAlign.center,
                                      )),
                                    )
                                  : Image.file(
                                      state.avatar,
                                      height: 118,
                                      width: 118,
                                      fit: BoxFit.cover,
                                    ).container(width: 118, height: 118),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ).paddingFromLTRB(0, 0, 4, 4),
                            ],
                          ),
                        ).paddingAll(15).onClick(() {
                          state.launchImagePicker();
                        }),
                      ),
                      Text("Enter GST Details").paddingAll(4),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: state.gstinController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //hintText: "Enter GST Details",
                          //helperText: "Enter GST Details",
                        ),
                      ).paddingAll(4),
                      Text("Enter Email Address").paddingAll(4),
                      TextFormField(
                        validator: (value) {
                          if (value.isNotEmpty && !value.validEmail())
                            return "Enter valid email";
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        controller: state.emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //hintText: "Enter Email Address",
                          //helperText: "Enter Email Address",
                        ),
                      ).paddingAll(4),
                      Text("Enter Your Mobile No").paddingAll(4),
                      TextFormField(
                        enabled: false,
                        validator: (value) {
                          if (value.length != 10)
                            return "Enter 10 digit mobile number";
                          return null;
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        controller:
                            TextEditingController(text: arguments['mobile']),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //hintText: "Enter Your Mobile No",
                          //helperText: "Your Mobile No is"
                        ),
                      ).paddingAll(4),
                      Text("Shop/House No & Street Name").paddingAll(4),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: state.addressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //hintText: "Shop/House No & Street Name",
                          //helperText: "Shop/House No & Street Name",
                        ),
                      ).paddingAll(4),
                      Text("City/Town/Village Area").paddingAll(4),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: state.cityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          //hintText: "City/Town/Village Area",
                          //helperText: "City/Town/Village Area",
                        ),
                      ).paddingAll(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              state.registerUser();
                            },
                            child: Text("Skip"),
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          if (state.loading)
                            RaisedButton(
                              color: Colors.green,
                              onPressed: () {},
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          else
                            RaisedButton.icon(
                              color: Colors.green,
                              textColor: Colors.white,
                              onPressed: () {
                                state.registerUser();
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                              label: Text("Next"),
                            ),
                        ],
                      ),
                    ],
                  ).paddingAll(24),
          ),
        ),
      ),
    );
  }
}
